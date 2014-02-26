module LucidShopify::Middleware
  class Graceful429 < LucidClient::Middleware::Base

    # Try request, if it raises 429 then retry after a delay. Assumes that
    # Shopify will eventually send a non-429 response.
    #
    def call( env )
      attempts = 0

      begin
        _request( env ).tap do |response|
          if response.status == 429
            raise Shopify429Error
          end
        end

      rescue Shopify429Error
        delay = ( attempts += 1 ) ** 2

        log_error "API call limit reached, retrying in #{delay * 1000} msec ..."

        sleep delay
        retry

      end
    end

    private

    # Duplicates +Faraday::Env+ object, so it is not overwritten on response.
    #
    def _request( env )
      app.call( env.dup )
    end

    class Shopify429Error < StandardError
    end

  end
end
