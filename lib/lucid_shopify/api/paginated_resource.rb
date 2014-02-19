module LucidShopify
  module PaginatedResource

    include LucidAsync::Mixin

    def all( params = {} )
      params = _default_params.merge( params )
      pages  = page_count( params )

      pages > 0 ? all_pages( pages, params ) : []
    end

    # Returns all resources on a given page.
    #
    def page( page, params = {} )
      params = _default_params.merge( params )
      params = params.merge( :page => page )

      r = session.get_resource( _resource, params )

      represent_each r
    end

    private

    def all_pages( pages, params )
      pages = async_map( 1..pages ) do |page|
        page( page, params )
      end

      pages.flatten
    end

    # Get the total resource count matching +params+ and divide by the given
    # limit (defaults to 50 if none given) per page.
    #
    def page_count( params )
      count = session.get_resource( "#{_resource}/count", params )
      pages = count / params[:limit].to_f || 50.0

      pages.ceil
    end

    def _default_params
      super.merge( :limit => 250 )
    end

    # Resource in question eg. 'products'.
    #
    def _resource
      String.new
    end

  end
end
