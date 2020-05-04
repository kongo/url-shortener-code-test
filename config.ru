require 'rack/reloader'
require_relative './url_short_web_app.rb'
require_relative './url_repository.rb'

use Rack::Reloader
run UrlShortWebApp.new(UrlRepository.new)
