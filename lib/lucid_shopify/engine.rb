if defined?( ::Rails )
  class LucidShopify::Engine < ::Rails::Engine

    isolate_namespace LucidShopify

    config.after_initialize do
      Dir.glob( config.root.join 'app/concerns/**/*.rb' ).each do |f|
        require_dependency f
      end

      LucidShopify.config[:plans_file] ||= plans_file
    end

    def plans_file
      ::Rails.application.root.join( 'config/plans.yml' )
    end

  end
end
