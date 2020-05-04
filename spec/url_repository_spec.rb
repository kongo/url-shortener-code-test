require_relative '../url_repository.rb'

describe UrlRepository do
  subject{ described_class.new }
  let(:test_url) { 'http://example.com/foo-bar' }

  describe '#new' do
    it 'initializes an empty repository' do
      expect(subject.all.empty?).to eq(true)
    end
  end

  describe '#add' do
    it 'adds item to repository' do
      expect{ subject.add(test_url) }.to change{ subject.all.count }.by(1)
    end

    it 'returns a slug' do
      result = subject.add(test_url)
      expect(result).to be_a(String)
      expect(result.length).to eq(described_class::SLUG_LENGTH)
    end
  end

  describe '#get' do
    let(:slug) { subject.add(test_url) }
    it 'returns URL that corresponds to provided slug' do
      expect(subject.get(slug)).to eq(test_url)
    end
  end

  describe '#all' do
    let(:items) { (1..7).map { |i| test_url + i.to_s } }
    before { items.each { |item| subject.add(item) } }

    it 'returns all the items' do
      expect(subject.all.count).to eq(7)
      items.each { |item| expect(subject.all.values).to include(item) }
    end
  end
end
