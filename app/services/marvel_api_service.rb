class MarvelApiService
  require 'httparty'
  require 'digest'

  MARVEL_PUBLIC_KEY = '07e3e205bebd46de31d15ee9a76d85c2'
  MARVEL_PRIVATE_KEY = 'cb116416e7b6451df4226e110970d61e15dcf22f'
  BASE_URL = 'https://gateway.marvel.com'

  def call
    fetch_comic_books
  end

  private
  def fetch_comic_books
    url = "#{BASE_URL}/v1/public/comics?ts=#{authentication[:timestamp]}&apikey=#{MARVEL_PUBLIC_KEY}&hash=#{authentication[:digest_hash]}"
    response = HTTParty.get(url)

    raise "API error: #{response.code}" unless response.success?

    response.parsed_response
  end

  def authentication
    timestamp = Time.now.to_s
    hash_string = timestamp + MARVEL_PRIVATE_KEY + MARVEL_PUBLIC_KEY
    hash = Digest::MD5.hexdigest(hash_string)

    auth = {
      timestamp: timestamp,
      digest_hash: hash
    }
  end
end
