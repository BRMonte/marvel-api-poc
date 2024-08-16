class MarvelApiService
  require 'httparty'
  require 'digest'

  BASE_URL = 'https://gateway.marvel.com'

  def call
    fetch_comic_books
  end

  private
  def fetch_comic_books
    url = "#{BASE_URL}/v1/public/comics?ts=#{authentication[:timestamp]}&apikey=#{ENV['MARVEL_PUBLIC_KEY']}&hash=#{authentication[:digest_hash]}"
    response = HTTParty.get(url)

    raise "API error: #{response.code}" unless response.success?

    response.parsed_response
  end

  def authentication
    timestamp = Time.now.to_s
    hash_string = timestamp + ENV['MARVEL_PRIVATE_KEY'] + ENV['MARVEL_PUBLIC_KEY']
    hash = Digest::MD5.hexdigest(hash_string)

    auth = {
      timestamp: timestamp,
      digest_hash: hash
    }
  end
end
