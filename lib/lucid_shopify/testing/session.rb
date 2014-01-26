module LucidShopify::Testing
  class Session < LucidShopify::Session

    def _default_connection
      LucidShopify::Testing::Connection.build
    end

  end
end
