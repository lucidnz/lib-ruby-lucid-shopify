module LucidShopify::Middleware
  class Token < LucidShopify::Middleware::Base

    def call( env )
      app.call( env ).on_complete do |env|
        if _access_token_error?( env )
          msg = "Shopify rejected the token"
          log_error msg

          raise LucidShopify::Exceptions::InvalidToken, msg
        end
      end
    end

    private

    def _access_token_error?( env )
      if env[:status] == 401
        env[:body] && env[:body] =~ /access token/
      end
    end

  end
end
