module LucidShopify
  class ProductAPI

    include LucidClient::API

    def all( params = {} )
      params = _default_params.merge( params )
      pages  = page_count( params )

      all_pages( pages, params ) unless pages == 0
    end

    # Returns all products in the given collection.
    #
    def in_collection( collection_id )
      all( :collection_id => collection_id )
    end

    # Returns all products on a given page.
    #
    def page( page, params = {} )
      params = _default_params.merge( params )
      params = params.merge( :page => page )

      r = session.get_resource( 'products', params )

      represent_each r
    end

    private

    def all_pages( pages, params )
      ( 1..pages ).inject( [] ) do |products, page|
        products += page( page, params )
      end
    end

    # Get the total number of products matching +params+ and divide by the
    # given limit (defaults to 50 if none given).
    #
    def page_count( params = published )
      params.dup.select! do |k, v|
        %i{ published_status collection_id }.include?( k )
      end

      products_count = session.get_resource( 'products/count', params )
      ( products_count / params[:limit].to_f || 50.0 ).ceil
    end

    def _default_params
      super.merge( published ).merge( :limit => 250 )
    end

    def published
      { :published_status => 'published' }
    end

    def _model
      LucidShopify.config[:product_model]
    end

  end
end
