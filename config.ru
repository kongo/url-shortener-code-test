require 'rack/reloader'
require_relative './url_short_web_app.rb'

use Rack::Reloader
run UrlShortWebApp.new
