module LucidShopify::Concerns
  module Session

    extend  ActiveSupport::Concern

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

    def unset_current_shop
      if current_shop || session['shop_uri']
        session['shop_uri'] = nil
      end
    end

    # Call as controller before_filter. Requires named route for
    # +shopify_authenticate_path+.
    #
    def authorize
      redirect_to application_authenticate_path unless current_shop
    end

    private

    def application_authenticate_path
      config_authenticate_path || main_app.shopify_authenticate_path
    rescue NoMethodError
      raise 'Authentication requires named route shopify_authentication_path'
    end

    def config_authenticate_path
      LucidShopify.config[:authenticate_path]
    end

    # Ensures the shop actually has a token, otherwise we'll want to
    # reauthenticate ...
    #
    def shop_with_token( shop )
      shop if shop && shop.token
    end

    # The shop model should implement +find_by+ and attributes +uri+ and
    # +token+.
    #
    def shop_model
      unless ( model = LucidShopify.config[:shop_model] ).respond_to?( :call )
        raise 'LucidShopify.config[:shop_model] expects callable'
      end

      model.call
    end

  end
end
