require 'yaml'
require 'json'

class UrlShortWebApp
  ROUTES = {
    create_slug: ->(req) { req.post? && req.path_info == '/' },
    use_slug:    ->(req) { req.get?  && req.path_info != '/' },
    index_slugs: ->(req) { req.get?  && req.path_info == '/' }
  }

  JSON_HEADERS = {"Content-Type" => "application/json"}

  def initialize(repository)
    @repo = repository
  end

  def call(env)
    req = Rack::Request.new(env)
    params = req.post? ? JSON.parse(req.body.gets) : {}
    dispatch get_route_name(req), req, params, @repo
  end

  def dispatch(route_name, req, params, repo)
    return response_404 if route_name.nil?
    send route_name, req, params, repo
  end

  def create_slug(req, params, repo)
    slug = repo.add(params['url'])
    [201, JSON_HEADERS, [{ short_url: slug, url: repo.get(slug) }.to_json] ]
  end

  def use_slug(req, params, repo)
    url = repo.get(req.path_info[1..])
    if url.nil?
      response_404
    else
      [301, { "Location" => url }, [{ url: url }.to_json] ]
    end
  end

  def index_slugs(req, params, repo)
    urls_for_json = repo.all.map { |k, v| { slug: k, url: v } }
    [200, JSON_HEADERS, [{ urls: urls_for_json }.to_json] ]
  end

  def response_404
    [404, {}, []]
  end

  def get_route_name(req)
    route = ROUTES.find { |key, val| key if val.call(req) }
    route.nil? ? nil : route.first
  end
end
