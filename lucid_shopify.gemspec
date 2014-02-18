$: << "#{File.dirname __FILE__}/lib"

require 'lucid_shopify/version'

Gem::Specification.new do |s|

  s.name                   = 'lucid_shopify'
  s.summary                = 'Shopify API interface.'
  s.description            = 'A basic but extensible Shopify API interface extending lucid_client.'
  s.license                = 'MIT'

  s.version                = LucidShopify::VERSION

  s.author                 = 'Kelsey Judson'
  s.email                  = 'kelsey@luciddesign.co.nz'
  s.homepage               = 'http://github.com/luciddesign/lucid_shopify'

  s.files                  = Dir.glob( 'lib/**/*' ) + %w{ README.md LICENSE }

  s.platform               = Gem::Platform::RUBY
  s.has_rdoc               = false

  s.required_ruby_version  = '>= 2.0.0'
  s.add_runtime_dependency   'lucid_client', '~> 0.0.0'

end
