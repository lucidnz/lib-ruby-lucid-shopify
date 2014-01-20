class LucidShopify::Session < LucidClient::Session

  attr_reader :token

  def initialize( options = {} )
    @token = options[:token]

    super( options )
  end

  private

  def _middleware
    [ LucidShopify::Middleware::CallLogger,
      LucidShopify::Middleware::Token ]
  end

  def _headers
    { 'X-Shopify-Access-Token' => token,
      'Content-Type'           => 'application/json' }
  end

  def _request_path( path )
    "/admin/#{normalize_path path}.json"
  end

  def normalize_path( path )
    path.sub( /^(\/admin)?\//, '' ).sub( /\.json$/, '' )
  end

end
