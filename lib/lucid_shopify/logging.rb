module LucidShopify
  module Logging

    include LucidClient::Logging

    private

    def log_key
      'Shopify API'
    end

  end
end
