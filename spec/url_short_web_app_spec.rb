require_relative '../url_short_web_app.rb'

describe UrlShortWebApp do
  let(:app) { UrlShortWebApp.new }

  describe '#route_name' do
    context 'create_slug route' do
      let(:req) { double(post?: true, get?: false, path_info: '/') }
      it 'detects route correctly' do
        expect(app.route_name(req)).to eq(:create_slug)
      end
    end

    context 'use_slug route' do
      let(:req) { double(post?: false, get?: true, path_info: '/foo') }
      it 'detects route correctly' do
        expect(app.route_name(req)).to eq(:use_slug)
      end
    end

    context 'index_slugs route' do
      let(:req) { double(post?: false, get?: true, path_info: '/') }
      it 'detects route correctly' do
        expect(app.route_name(req)).to eq(:index_slugs)
      end
    end

    context 'no familiar route given' do
      let(:req) { double(post?: false, get?: false, path_info: 'invalid') }
      it 'returns nil without failing' do
        expect(app.route_name(req)).to be_nil
      end
    end
  end
end
