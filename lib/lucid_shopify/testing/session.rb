module LucidShopify::Testing
  class Session < LucidShopify::Session

    def initialize( options = {} )
      super( options )

      connection.builder.tap do |f|
        replace_adapter( f )
      end
    end

    private

    def _default_uri
      'https://example.myshopify.com'
    end

    # Assumes the adapter is the last item on the middleware stack (as it
    # should be).
    #
    def replace_adapter( f )
      f.handlers.pop

      f.adapter( :test ) do |api|
        LucidShopify::Testing::Connection.assign_stubs( api )
      end
    end

  end
end
