require 'yaml'

module LucidShopify::Billing
  class Plan

    attr_reader :handle, :config

    def initialize( handle, config )
      @handle = handle
      @config = config
    end

    # Builds up a Plan according to it's configuration in
    # +config/plans.yml+.
    #
    def self.for_handle( handle )
      new( handle, config[handle] ) if config[handle]
    end

    # List only plan handles.
    #
    def self.list
      config.keys
    end

    def self.all
      list.map { |handle| for_handle( handle ) }
    end

    def self.config
      unless plans_file = LucidShopify.config[:plans_file]
        raise 'LucidShopify.config[:plans_file] is unset'
      end

      yaml = File.read( plans_file )

      YAML.load( yaml )
    end

    # Getters for each property in +config/plans.yml+.
    #
    config.first.last.keys.each do |property|
      define_method( property ) { config[property] }
    end

    if instance_methods.include?( :paid )

      alias_method :paid?, :paid

      def self.paid
        all.select( &:paid? )
      end

    end

    # Only supports a single currency format for the time being.
    #
    def price_text
      price_format( price )
    end

    # Attempts to format price as "$10" rather than "$10.00".
    #
    # To avoid potential danger scenario ... will return #price_text if the
    # price is not in fact an integer. We don't want prices misrepresented!
    #
    def price_format( price )
      price % 1 == 0 ? "$#{price.to_i}" : '$%.2f' % price
    end

    def to_s
      name
    end

  end
end
