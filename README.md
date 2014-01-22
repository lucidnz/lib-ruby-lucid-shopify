lucid_shopify
=============

`lucid_shopify` provides basic interfaces to the Shopify API including
authentication, validation, webhooks, billing and a small subset of common API
calls. Each interface is designed for extension and provides only a base from
which to start.

It is designed around my own workflows and experiences and is not intended to
cover every possible scenario.


### Examples

Generally, interfaces to remote resources will be used with resource mappings
which are provided by `lucid_client`. The following example illustrates how
this might be achieved.

First we implement a model with the `LucidClient::Model` interface:

    class Product

      extend LucidClient::Model

      attr_accessor :name

      def self.resource_mappings
        { :name => 'title', :description => 'body_html' }
      end

    end

Then we subclass the API and override the `#all` and `#_fields` methods:

    class ProductAPI < LucidShopify::ProductAPI

      def all( params = {} )
        represent_each ::Product, super( params )
      end

      private

      def _fields
        ::Product.fields
      end

    end
