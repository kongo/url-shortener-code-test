class UrlRepository
  SLUG_LENGTH = 6

  def initialize
    @storage = {}
  end

  def add(url)
    slug = generate_uniq_slug
    @storage[slug] = url
    slug
  end

  def get(slug)
    @storage[slug]
  end

  def all
    @storage
  end

  private

  def generate_uniq_slug
    begin
      slug = generate_slug
    end while @storage.key?(slug)
    slug
  end

  def generate_slug
    rand(36 ** SLUG_LENGTH).to_s(36)
  end
end
