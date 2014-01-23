if defined?( ::Rails )
  class LucidShopify::Engine < ::Rails::Engine

    isolate_namespace LucidShopify

    config.after_initialize do
      Dir.glob( config.root.join 'app/concerns/**/*.rb' ).each do |f|
        require_dependency f
      end
    end

  end
end
