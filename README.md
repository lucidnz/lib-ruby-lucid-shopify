lucid_shopify
=============

`lucid_shopify` is an interface to the Shopify API providing authentication,
validation and a small subset of API calls. It is designed with extension in
mind and intended as a base for future projects.

It is quite opinionated and built around my own workflow.


### Examples

Generally, this will be used with resource mappings. The following example
illustrates how we might achieve this.

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
