$: << "#{File.dirname __FILE__}/lib"

gem = :lucid_shopify

require "#{gem}/version"

task :build do
  system "gem build #{gem}.gemspec"
end

task :release => :build do
  system "gem push #{gem}-#{LucidShopify::VERSION}.gem"
end

task :install => :build do
  system "gem install #{gem}-#{LucidShopify::VERSION}.gem"
end

task :clean do
  system "rm #{gem}-*.gem"
end
