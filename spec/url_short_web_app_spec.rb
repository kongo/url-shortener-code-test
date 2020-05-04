require_relative '../url_short_web_app.rb'

describe UrlShortWebApp do
  let(:app) { UrlShortWebApp.new(double('UrlRepository')) }

  describe '#get_route_name' do
    context 'create_slug route' do
      let(:req) { double(post?: true, get?: false, path_info: '/') }
      it 'detects route correctly' do
        expect(app.get_route_name(req)).to eq(:create_slug)
      end
    end

    context 'use_slug route' do
      let(:req) { double(post?: false, get?: true, path_info: '/foo') }
      it 'detects route correctly' do
        expect(app.get_route_name(req)).to eq(:use_slug)
      end
    end

    context 'index_slugs route' do
      let(:req) { double(post?: false, get?: true, path_info: '/') }
      it 'detects route correctly' do
        expect(app.get_route_name(req)).to eq(:index_slugs)
      end
    end

    context 'no familiar route given' do
      let(:req) { double(post?: false, get?: false, path_info: 'invalid') }
      it 'returns nil without failing' do
        expect(app.get_route_name(req)).to be_nil
      end
    end
  end

  describe '#dispatch' do
    let(:req) { double('request') }

    context 'empty route given' do
      it 'responds with 404' do
        expect(app.dispatch(nil, req)).to eq([404, {}, []])
      end
    end

    context 'actual route given' do
      it 'calls corresponding action method' do
        expect(app).to receive(:create_slug).with(req).and_return(:create_slug_result )
        expect(app.dispatch(:create_slug, req)).to eq(:create_slug_result)

        expect(app).to receive(:use_slug).with(req).and_return(:use_slug_result)
        expect(app.dispatch(:use_slug, req)).to eq(:use_slug_result)

        expect(app).to receive(:index_slugs).with(req).and_return(:index_slugs_result)
        expect(app.dispatch(:index_slugs, req)).to eq(:index_slugs_result)
      end
    end
  end
end
