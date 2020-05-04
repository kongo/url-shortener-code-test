require 'yaml'

class UrlShortWebApp
  ROUTES = {
    create_slug: ->(req) { req.post? && req.path_info == '/' },
    use_slug:    ->(req) { req.get?  && req.path_info != '/' },
    index_slugs: ->(req) { req.get?  && req.path_info == '/' }
  }

  def call(env)
    req = Rack::Request.new(env)
    dispatch get_route_name(req), req

    # [
    #   200,
    #   {},
    #   [req.to_yaml]
    # ]
  end

  def dispatch(route_name, req)
    return response_404 if route_name.nil?
    send route_name, req
  end

  def create_slug(req)
    #
  end

  def use_slug(req)
    #
  end

  def index_slugs(req)
    #
  end

  def response_404
    [404, {}, []]
  end

  def get_route_name(req)
    route = ROUTES.find { |key, val| key if val.call(req) }
    route.nil? ? nil : route.first
  end
end
