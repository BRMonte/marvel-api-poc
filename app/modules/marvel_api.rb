module MarvelApi

  BASE_URL = 'https://gateway.marvel.com'

  ENDPOINTS = {
    comics: '/v1/public/comics',
    characters: '/v1/public/characters',
  }

  def self.base_url
    BASE_URL
  end

  def self.endpoint(name)
    ENDPOINTS[name.downcase.to_sym]
  end

  def self.credentials
    timestamp = Time.now.to_s
    {
      timestamp: timestamp,
      digest_hash: generate_hash(timestamp),
      api_key: ENV['MARVEL_PUBLIC_KEY']
    }
  end

  private

  def self.generate_hash(timestamp)
    hash_string = timestamp + ENV['MARVEL_PRIVATE_KEY'] + ENV['MARVEL_PUBLIC_KEY']
    Digest::MD5.hexdigest(hash_string)
  end
end
