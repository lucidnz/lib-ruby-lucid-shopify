module LucidShopify::Middleware
  class CallLogger < LucidShopify::Middleware::Base

    # This class breaks in Faraday 0.9.0 (which breaks compatibility with
    # just about everything by the sound of things).

    def call( env )
      _log_request( env )

      app.call( env ).on_complete do |env|
        _log_response( env )
      end
    end

    private

    def _log_request( env )
      method, uri = env[:method].to_s.upcase, env[:url].to_s

      log "\e[36m%s \e[37m%s" % [ method, uri ]
    end

    def _log_response( env )
      log "Response #{env[:response][:status]}"
      log "Requests #{env[:response_headers][_api_header]}"
    end

    def _api_header
      'HTTP_X_SHOPIFY_SHOP_API_CALL_LIMIT'
    end

  end
end
