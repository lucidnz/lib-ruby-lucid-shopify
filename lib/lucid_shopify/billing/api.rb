module LucidShopify::Billing
  class API

    include LucidClient::API

    # Create a recurring application charge. If the charge was successfully
    # created, then this will return a +confirmation_url+ where the shop owner
    # may either accept or decline the charge.
    #
    # Otherwise +nil+.
    #
    def subscribe( plan, options = {} )
      options  = plan_to_charge( plan, options )
      response = session.post_as_json( 'recurring_application_charges', options )

      if response.status == 201
        session.parse_resource( response )['confirmation_url']
      end
    end

    # Activate a subscription after shop owner has accepted a charge.
    #
    def process_subscription( charge_id )
      charge = get_charge charge_id
      status = charge && charge['status']

      if status == 'accepted'
        activate_subscription( charge )
      end
    end

    def unsubscribe( charge_id )
      delete "recurring_application_charges/#{charge_id}"
    end

    def get_charge( charge_id )
      response = get "recurring_application_charges/#{charge_id}"

      if response.status == 200
        session.parse_resource( response )
      end
    end

    def charge_accepted?( charge_id )
      resource = get_charge charge_id

      resource && resource['status'] == 'accepted'
    end

    private

    def plan_to_charge( plan, options = {} )
      {
        resource_type => {
          :name       => plan.handle,
          :price      => plan.price,
          :return_url => _billing_uri,
          :test       => options[:test] || false
        }
      }
    end

    # Returns the charge name (should be plan handle) if successful, so that
    # we can assign the appropriate plan locally.
    #
    def activate_subscription( resource )
      id       = resource['id']
      path     = "recurring_application_charges/#{id}/activate"
      response = session.post_as_json path, resource_type => resource

      if response.status == 200
        resource['name']
      end
    end

    # Shopify sends shop owners here after they accept or decline a charge.
    #
    def _billing_uri
      if uri = LucidShopify.config[:billing_uri]
        return uri
      end

      raise 'BillingAPI requires LucidShopify.config[:billing_uri]'
    end

    # Such a looong name ...
    #
    def resource_type
      :recurring_application_charge
    end

  end
end
