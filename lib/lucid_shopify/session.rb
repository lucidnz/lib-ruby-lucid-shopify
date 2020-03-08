class LucidShopify::Session < LucidClient::Session

  attr_reader :token

  def initialize( options = {} )
    @token = options[:token]

    super( options )
  end

  # +shop+ must implement both +#uri+ and +#token+.
  #
  def self.for_shop( shop, options = {} )
    options.merge!( :uri => shop.uri, :token => shop.token )

    new( options )
  end

  private

  def _middleware
    %i{ Retry Graceful429 CallLogger Token }.map do |middleware|
      LucidShopify::Middleware.const_get( middleware )
    end
  end

  def _headers
    { 'X-Shopify-Access-Token' => token,
      'Content-Type'           => 'application/json' }
  end

  def _request_path( path )
    "/admin/api/#{LucidShopify.config.fetch :api_version, '2019-04'}/#{normalize_path path}.json"
  end

  def normalize_path( path )
    path.sub( /^\//, '' ).sub( /\.json$/, '' )
  end

end
