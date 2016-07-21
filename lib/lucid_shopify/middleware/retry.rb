module LucidShopify::Middleware
  class Retry < LucidShopify::Middleware::Base

    ATTEMPTS = 3
    DELAY = 0.1
    EXCEPTIONS = [
      Faraday::Error::ConnectionFailed,
      Faraday::Error::TimeoutError
    ]

    # Retries on connection and timeout errors.
    #
    def call( env )
      attempts = 0

      begin
        app.call( env.dup )
      rescue *EXCEPTIONS => e
        attempts += 1
        raise e if attempts >= ATTEMPTS

        log_error "Connection failed, retrying in #{DELAY * 1000} msec ..."

        sleep DELAY
        retry
      end
    end

  end
end
