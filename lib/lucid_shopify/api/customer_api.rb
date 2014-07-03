module LucidShopify
  class CustomerAPI

    include LucidClient::API
    include LucidShopify::PaginatedResource

    private

    def _model
      callable LucidShopify.config[:customer_model]
    end

    def _resource
      'customers'
    end

  end
end
