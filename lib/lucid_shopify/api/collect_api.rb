module LucidShopify
  class CollectAPI

    include LucidClient::API
    include LucidShopify::PaginatedResource

    def in_collection( collection_id, options = {} )
      all options.merge( :collection_id => collection_id )
    end

    private

    def _model
      LucidShopify.config[:collect_model].call
    end

    def _resource
      'collects'
    end

  end
end
