require 'yaml'

class UrlShortWebApp
  ROUTES = {
    create_slug: ->(req) { req.post? && req.path_info == '/' },
    use_slug:    ->(req) { req.get?  && req.path_info != '/' },
    index_slugs: ->(req) { req.get?  && req.path_info == '/' }
  }

  def call(env)
    req = Rack::Request.new(env)
    [
      200,
      {},
      [req.to_yaml]
    ]
  end

  def route_name(req)
    route = ROUTES.find { |key, val| key if val.call(req) }
    route.nil? ? nil : route.first
  end
end
