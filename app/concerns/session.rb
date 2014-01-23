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
      redirect_to authenticate_path unless current_shop
    end

    # Ensures the shop actually has a token, otherwise we'll want to
    # reauthenticate ...
    #
    def shop_with_token( shop )
      shop if shop && shop.token
    end

    def shop_model
      if model = LucidShopify.config[:shop_model]
        model
      else
        raise 'LucidShopify.config[:shop_model] should be set'
      end
    end

  end
end
