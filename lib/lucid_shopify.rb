require 'lucid_client'

module LucidShopify

  extend LucidClient::Env

end

require 'lucid_shopify/logging'

middleware = File.dirname( __FILE__ ) + '/lucid_shopify/middleware/*.rb'

Dir.glob( middleware ).each do |middleware|
  require middleware
end

require 'lucid_shopify/session'
require 'lucid_shopify/invalid_token_error'
require 'lucid_shopify/authenticate'
