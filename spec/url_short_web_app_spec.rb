require_relative '../url_short_web_app.rb'

describe UrlShortWebApp do
  subject { UrlShortWebApp.new('UrlRepository') }
  let(:req)    { double('request') }
  let(:params) { double('params')  }
  let(:repo)   { double('repo', add: nil, get: nil, all: nil) }
  let(:test_url) { 'http://example.com/foo-bar' }

  describe '#get_route_name' do
    context 'create_slug route' do
      let(:req) { double(post?: true, get?: false, path_info: '/') }
      it 'detects route correctly' do
        expect(subject.get_route_name(req)).to eq(:create_slug)
      end
    end

    context 'use_slug route' do
      let(:req) { double(post?: false, get?: true, path_info: '/foo') }
      it 'detects route correctly' do
        expect(subject.get_route_name(req)).to eq(:use_slug)
      end
    end

    context 'index_slugs route' do
      let(:req) { double(post?: false, get?: true, path_info: '/') }
      it 'detects route correctly' do
        expect(subject.get_route_name(req)).to eq(:index_slugs)
      end
    end

    context 'no familiar route given' do
      let(:req) { double(post?: false, get?: false, path_info: 'invalid') }
      it 'returns nil without failing' do
        expect(subject.get_route_name(req)).to be_nil
      end
    end
  end

  describe '#dispatch' do
    context 'empty route given' do
      it 'responds with 404' do
        expect(subject.dispatch(nil, req, nil, nil)).to eq([404, {}, []])
      end
    end

    context 'actual route given' do
      it 'calls corresponding action method' do
        expect(subject).to receive(:create_slug).with(req, params, repo).and_return(:create_slug_result )
        expect(subject.dispatch(:create_slug, req, params, repo)).to eq(:create_slug_result)

        expect(subject).to receive(:use_slug).with(req, params, repo).and_return(:use_slug_result)
        expect(subject.dispatch(:use_slug, req, params, repo)).to eq(:use_slug_result)

        expect(subject).to receive(:index_slugs).with(req, params, repo).and_return(:index_slugs_result)
        expect(subject.dispatch(:index_slugs, req, params, repo)).to eq(:index_slugs_result)
      end
    end
  end

  describe '#create_slug' do
    it 'adds given url to the repo' do
      expect(repo).to receive(:add).with(test_url)
      subject.create_slug(req, {'url' => test_url}, repo)
    end

    it 'returns correct Rack response' do
      expect(subject.create_slug(req, {'url' => test_url}, repo)).to be_correct_rack_response
    end
  end

  describe '#index_slugs' do
    it 'provides all items from the repo' do
      expect(repo).to receive(:all)
      subject.index_slugs(req, params, repo)
    end
    it 'returns correct Rack response' do
      expect(subject.index_slugs(req, params, repo)).to be_correct_rack_response
    end
  end

  describe '#use_slug' do
    before do
      allow(req).to receive(:path_info).and_return '/slug'
    end

    it 'understands given params correctly' do
      expect(repo).to receive(:get).with('slug')
      subject.use_slug(req, nil, repo)
    end

    context 'given slug is not present in the repo' do
      before do
        allow(req).to receive(:path_info).and_return '/slug'
      end

      it 'responds 404' do
        expect(repo).to receive(:get).with('slug').and_return nil
        subject.use_slug(req, nil, repo)
      end
    end

    context 'given slug is present in the repo' do
      before do
        allow(req).to receive(:path_info).and_return '/slug'
      end

      it 'redirects to the corresponding website' do
        expect(repo).to receive(:get).with('slug').and_return test_url
        response = subject.use_slug(req, nil, repo)
        expect(response[0]).to eq(301)
        expect(response[1]).to eq({ "Location" => test_url })
      end
    end
  end
end
