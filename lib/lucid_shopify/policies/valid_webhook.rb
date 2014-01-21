require 'digest'
require 'base64'

module LucidShopify::Policies
  class ValidWebhook

    attr_reader :request

    def initialize( request )
      @request = request
    end

    def valid?
      signature            = request.headers['X-Shopify-Hmac-SHA256']
      calculate_signature == signature
    end

    private

    def calculate_signature
      digest    = OpenSSL::Digest::SHA256.new
      signature = OpenSSL::HMAC.digest( digest, secret, request.body.read )

      Base64.encode64( signature ).strip
    end

    def secret
      LucidShopify.client_env( :secret )
    end

  end
end
