lucid_shopify
=============

`lucid_shopify` provides basic interfaces to the Shopify API including
authentication, validation, webhooks, billing and a small subset of common API
calls. Each interface is designed for extension and provides only a base from
which to start.

It is designed around my own workflows and experiences and is not intended to
cover every possible scenario. It is also unstable and subject to change as I
figure out the details.


Examples
--------

### Authentication

Authentication is handled by `LucidShopify::Authenticate`. All you need is
the shop handle/URI. See the source documentation for details.


### Billing

Billing requires implementation of a `plan` interface responding to `#handle`
and `#price`. For example:

    class Plan

      attr_reader :plan, :price

      def initialize( plan, price )
        @plan, @price = plan, price
      end

    end

With this, you can create a recurring application charge with `#subscribe`.
If successful, this will return a confirmation URI with which to redirect the
shop owner so they may accept of decline a charge. Ensure that you've set
`:billing_uri` in `LucidShopify.config` as this is where the shop owner will
return to your app.

    confirmation_uri = billing_api.subscribe( plan )

When the user returns, the request params should include `id`, which you
should pass to `#process_subscription`. If the shop owner accepted, this will
activate the charge. If the shop owner declined, this will return `nil`.

    billing_api.process_subscription( charge_id )

To unsubscribe, pass the `charge_id` to `#unsubscribe` (so keep track of
that `id`).


### Resource Mappings

Generally, interfaces to remote resources will be used with resource mappings
which are provided by `lucid_client`. The following example illustrates how
this might be achieved.

First we implement a model with the `LucidClient::Model` interface:

    class Product

      include LucidClient::Model

      map_resources do
        { :name => 'title', :description => 'body_html' }
      end

    end

Then we subclass the API and override the `#all` and `#_fields` methods:

    class ProductAPI < LucidShopify::ProductAPI

      def all( params = {} )
        represent_each super( params )
      end

      private

      def _model
        ::Product
      end

    end

Actually ... this second step is no longer necessary (but still serves as a
nice example of wrapping the calls in subclasses) and now all that is needed
is to set `config[:product_model]`:

    LucidShopify.config[:product_model] = ::Product


### Webhook Verification

When handling webhook requests, you'll almost always want to verify the source
of the request. This can be done with `LucidShopify::Policies::ValidWebhook`
which checks the request signature to ensure that the request originated from
Shopify.

    LucidShopify::Policies::ValidWebhook.new( request ).valid?
