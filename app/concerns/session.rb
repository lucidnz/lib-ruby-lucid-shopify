module LucidShopify::Concerns
  module Session

    extend ActiveSupport::Concern

    included do
      helper_method :current_shop
    end

    def current_shop
      if session['shop_uri']
        @current_shop ||= shop_model.find_by( :uri => session['shop_uri'] )

        shop_with_token( @current_shop )
      end
    end

    def set_current_shop( shop )
      session['shop_uri'] = shop.uri
    end

    private

    # Call as controller before_filter.
    #
    def authorize
      unless authenticate_path = LucidShopify.config[:authenticate_path]
        raise 'LucidShopify.config[:authenticate_path] is unset'
      end

      redirect_to authenticate_path unless current_shop
    end

    # Ensures the shop actually has a token, otherwise we'll want to
    # reauthenticate ...
    #
    def shop_with_token( shop )
      shop if shop && shop.token
    end

    def shop_model
      unless model = LucidShopify.config[:shop_model]
        raise 'LucidShopify.config[:shop_model] should be set'
      end

      ensure_shop_interface!( model )
      model
    end

    # Ensure that model implements the required interface.
    #
    def ensure_shop_interface!( model )
      unless shop_interface?( model )
        raise "#{model} does not implement the Shop interface"
      end
    end

    def shop_interface?( model )
      %i{ uri token find_by }.inject( true ) do |bool, method|
        bool && model.respond_to?( method )
      end
    end

  end
end
