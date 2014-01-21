module LucidShopify
  class CollectionAPI

    include LucidClient::API

    # Expects model +Collection+ implementing +LucidClient::Model+. Returns
    # all Custom Collections and Smart Collections matching +params+.
    #
    def all( params = {} )
      params.merge!( :fields => Collection.fields, :limit  => 250 )

      r  = session.get_resource( 'custom_collections', params )
      r += session.get_resource( 'smart_collections',  params )

      LucidClient::Resource.map( Collection, r )
    end

    # Returns only collections which contain the given product.
    #
    def with_product( product_id )
      all( :product_id => product_id )
    end

  end
end
