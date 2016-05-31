require 'faraday'
require 'digest'
require 'json'

module LucidShopify

  # Used to authenticate a shop and receive an access token through OAuth2.
  # Instantiate with the shop's handle (such as +"my-shop"+) and then redirect
  # the client browser to the URI returned by +#code_uri+.
  #
  #     auth = LucidShopify::Authenticate.new( handle )
  #     redirect_to auth.code_uri
  #
  # When the user returns (at the location specified by attribute
  # +callback_uri+), you validate the request signature and then request a
  # token.
  #
  # This can also be performed in a single step:
  #
  #     auth  = LucidShopify::Authenticate.new( handle )
  #     token = auth.request_token_with_validation( params )
  #
  # Shopify tokens do not expire, but you can reauthenticate with a new token
  # at any time.
  #
  class Authenticate

    attr_accessor *%i{ shop_handle scope api_key secret callback_uri token }

    def initialize( shop_handle, options = {} )
      @shop_handle = normalize_handle( shop_handle )
      @token       = options[:token]
      @scope       = options[:scope] || 'read_products'

      %i{ api_key secret callback_uri }.each do |var|
        self.send "#{var}=", options[var] || LucidShopify.client_env( var )
      end
    end

    def request_token_with_validation( params )
      if valid_signature?( params )
        request_token( params['code'] )
      end
    end

    # Get an authorization code by redirecting the user to the +code_uri+.
    # The response parameters will include +params['code']+.
    #
    def request_token( code )
      params = { :client_id     => api_key,
                 :client_secret => secret,
                 :code          => code }

      response        = Faraday.post( token_uri, params )
      response_params = JSON.parse( response.body )

      @token = response_params['access_token']
    end

    # Verify that the authorization code request originated from Shopify. See
    # the Shopify OAuth documentation which details this procedure.
    #
    def valid_signature?( params )
      sanitize_params_hash( params )

      hmac     = params.delete( 'hmac' )
      msg      = params.map { |k, v| "#{k}=#{v}" }.sort.join( ?& )
      digest   = OpenSSL::Digest.new( 'sha256' )
      msg_hmac = OpenSSL::HMAC.hexdigest( digest, secret, msg )

      msg_hmac == hmac
    end

    def uri
      "https://#{domain}"
    end

    def domain
      "#{shop_handle}.myshopify.com"
    end

    # Redirect user to this path for authorization.
    #
    def code_uri
      "#{auth_uri}?client_id=#{api_key}&scope=#{scope}"
    end

    private

    # Handles instantiation with alternatively formatted shop handles and
    # reformats to the format "shop-name", eg.
    #
    #     shop-handle.myshopify.com -> Shopify callback's params['shop']
    #     Shop Handle               -> Possible user input
    #
    def normalize_handle( shop_handle )
      strip_myshopify_domain( shop_handle ).downcase.gsub( /\s/, '-' )
    end

    def strip_myshopify_domain( shop_handle )
      shop_handle.split( '.' ).first || ''
    end

    # Clear out any annoying Rails keys polluting the params hash so they
    # don't interfere with the signature verification algorithm.
    #
    # Also delete the deprecated "signature" param.
    #
    def sanitize_params_hash( params )
      if defined?( ::Rails )
        %w{ controller action signature }.each { |k| params.delete( k ) }
      end
    end

    def auth_uri
      uri + auth_path
    end

    def token_uri
      uri + token_path
    end

    def auth_path
      '/admin/oauth/authorize'
    end

    def token_path
      '/admin/oauth/access_token'
    end

  end
end
