module LucidShopify
  class ProductAPI

    include LucidClient::API
    include LucidShopify::PaginatedResource

    def in_collection( collection_id, options = {} )
      all options.merge( :collection_id => collection_id )
    end

    private

    def _default_params
      super.merge( :published_status => 'published' )
    end

    def _model
      callable LucidShopify.config[:product_model]
    end

    def _resource
      'products'
    end

  end
end
