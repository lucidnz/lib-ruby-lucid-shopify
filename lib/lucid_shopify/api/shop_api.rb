module LucidShopify
  class ShopAPI

    include LucidClient::API

    def meta( params = {} )
      params = _default_params.merge( params )
      session.get_resource( 'shop', params  )
    end

  end
end
