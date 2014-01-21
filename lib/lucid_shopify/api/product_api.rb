module LucidShopify
  class ProductAPI

    include LucidClient::API

    # Expects model +Product+ implementing +LucidClient::Model+. Returns all
    # Products matching +params+.
    #
    def all( params = {} )
      params.merge!( default_params )
      pages = page_count( params )

      all_pages( pages, params ) unless pages == 0
    end

    # Returns all products in the given collection.
    #
    def in_collection( collection_id )
      all( :collection_id => collection_id )
    end

    private

    def all_pages( pages, params )
      r = ( 1..pages ).inject( [] ) do |products, page|
        product_params  = params.merge( :page => page )
        products       += session.get_resource( 'products', product_params )
      end

      LucidClient::Resource.map( Product, r )
    end

    # Get the total number of products matching +params+ and divide by the
    # limit of 250.
    #
    def page_count( params = published )
      params.dup.select! do |k, v|
        %i{ published_status collection_id }.include?( k )
      end

      products_count = session.get_resource( 'products/count', params )
      ( products_count / 250.0 ).ceil
    end

    def default_params
      published.merge( :fields => Product.fields, :limit => 250 )
    end

    def published
      { :published_status => 'published' }
    end

  end
end
