module LucidShopify::Testing
  class Connection < LucidClient::Testing::Connection

    stub_json_tree File.dirname( __FILE__ ) + '/api'

  end
end
