$: << './lib'
$: << '../lucid_client/lib'

require 'lucid_client'
require 'lucid_shopify'

if File.exist?( f = '.pryrc.local' )
  load f
end
