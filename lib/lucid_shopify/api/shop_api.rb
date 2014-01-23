module LucidShopify
  class ShopAPI

    include LucidClient::API

    def meta( params = {} )
      params = _default_params.merge( params )
      r      = session.get_resource( 'shop', params  )

      represent r
    end

    private

    def _model
      LucidShopify.config[:shop_model]
    end

  end
end
