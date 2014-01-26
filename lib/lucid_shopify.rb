require 'lucid_client'

module LucidShopify

  extend LucidClient::Env

end

require 'lucid_shopify/engine'
require 'lucid_shopify/logging'

middleware = File.dirname( __FILE__ ) + '/lucid_shopify/middleware/*.rb'

Dir.glob( middleware ).each do |middleware|
  require middleware
end

require 'lucid_shopify/session'
require 'lucid_shopify/invalid_token_error'
require 'lucid_shopify/services/authenticate'
require 'lucid_shopify/policies/valid_webhook'

### API Interfaces

require 'lucid_shopify/api/shop_api'
require 'lucid_shopify/api/collection_api'
require 'lucid_shopify/api/product_api'
require 'lucid_shopify/api/webhook_api'
require 'lucid_shopify/api/billing_api'

### Testing

require 'lucid_shopify/testing/connection'
