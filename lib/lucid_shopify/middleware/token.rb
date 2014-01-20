module LucidShopify::Middleware
  class Token

    include LucidClient::Logging

    attr_reader :app

    def initialize( app )
      @app = app
    end

    def call( env )
      app.call( env ).on_complete do |env|
        if access_token_error?( env )
          msg = "Shopify rejected the token"
          log_error msg

          raise LucidShopify::InvalidTokenError, msg
        end
      end
    end

    private

    def access_token_error?( env )
      if env[:status] == 401
        env[:body] && env[:body] =~ /access token/
      end
    end

  end
end
