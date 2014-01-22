module LucidShopify
  class CollectionAPI

    include LucidClient::API

    def all( params = {} )
      params = _default_params.merge( params )

      r = session.get_resource( 'custom_collections', params )
      r + session.get_resource( 'smart_collections',  params )
    end

    # Returns only collections which contain the given product.
    #
    def with_product( product_id )
      all( :product_id => product_id )
    end

    private

    def _default_params
      super.merge( :limit => 250 )
    end

  end
end
