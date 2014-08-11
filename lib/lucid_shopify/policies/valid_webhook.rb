require 'digest'
require 'base64'

module LucidShopify::Policies
  class ValidWebhook

    attr_reader :request

    def initialize( request )
      @request = request
    end

    def valid?
      signature            = request.env['HTTP_X_SHOPIFY_HMAC_SHA256']
      calculate_signature == signature
    end

    def invalid?
      !valid?
    end

    private

    def calculate_signature
      digest    = OpenSSL::Digest::SHA256.new
      signature = OpenSSL::HMAC.digest( digest, secret, read_request_body )

      Base64.encode64( signature ).strip
    end

    def read_request_body
      ( io = request.body ).read.tap { io.rewind }
    end

    def secret
      LucidShopify.client_env( :secret )
    end

  end
end
