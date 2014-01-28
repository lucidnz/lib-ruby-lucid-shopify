module LucidShopify::Concerns
  module Session

    extend  ActiveSupport::Concern
    include LucidClient::RailsCheck

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
      attrs = active_record?( model ) ? :column_names : :instance_methods

      methods = %w{ uri token }.inject( true ) do |bool, method|
        bool && model.send( attrs ).include?( method )
      end

      model.respond_to?( :find_by ) && methods
    end

  end
end
