module LucidShopify
  class WebhookAPI

    include LucidClient::API
    include LucidAsync::Mixin

    def all( params = {} )
      params = _default_params.merge( params )

      r = session.get_resource( 'webhooks', params )

      represent_each r
    end

    def unset( webhook_id )
      delete( "webhooks/#{webhook_id}" )
    end

    def unset_all
      all = session.get_resource( 'webhooks', _unset_params )

      async_each( all ) do |webhook|
        unset( webhook['id'] )
      end
    end

    ### Initialization

    def set( topic )
      response = session.post_as_json 'webhooks', resource_for( topic )
      response.status == 201
    end

    def set_all_for( type )
      async_each( %w{ create update delete } ) do |action|
        set( "#{type}/#{action}" )
      end
    end

    def set_uninstalled
      set( 'app/uninstalled' )
    end

    private

    def resource_for( topic )
      {
        :webhook => {
          :topic   => topic,
          :address => _webhook_uri,
          :format  => 'json'
        }
      }
    end

    def _unset_params
      { :fields => 'id', :address => _webhook_uri }
    end

    def _default_params
      super.merge( :address => _webhook_uri )
    end

    def _webhook_uri
      if uri = LucidShopify.config[:webhook_uri]
        return uri
      end

      raise 'WebhookAPI requires LucidShopify.config[:webhook_uri]'
    end

    def _model
      callable LucidShopify.config[:webhook_model]
    end

  end
end
