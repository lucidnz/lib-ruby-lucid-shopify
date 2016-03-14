module LucidShopify
  class OrderAPI

    include LucidClient::API
    include LucidShopify::PaginatedResource

    private

    def _model
      callable LucidShopify.config[:order_model]
    end

    def _resource
      'orders'
    end

  end
end
