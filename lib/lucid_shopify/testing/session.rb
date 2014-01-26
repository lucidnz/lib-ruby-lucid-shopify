module LucidShopify::Testing
  class Session < LucidShopify::Session

    def _test_adapter( connection )
      connection.adapter( :test ) do |api|
        LucidShopify::Testing::Connection.assign_stubs( api )
      end
    end

  end
end
