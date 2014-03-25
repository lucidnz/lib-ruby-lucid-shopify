module LucidShopify::Middleware
  class Base < LucidClient::Middleware::Base

    def log_key
      'LucidShopify'
    end

  end
end
