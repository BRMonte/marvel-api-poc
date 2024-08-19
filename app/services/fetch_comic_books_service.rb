class FetchComicBooksService
  require 'httparty'
  require 'digest'

  MARVEL_BASE_URL = 'https://gateway.marvel.com'

  def call
    marvel_api
  end

  private

  def marvel_api
    ts, digest_hash = authentication.values_at(:timestamp, :digest_hash)
    url = "#{MARVEL_BASE_URL}/v1/public/comics?ts=#{ts}&apikey=#{ENV['MARVEL_PUBLIC_KEY']}&hash=#{digest_hash}"

    begin
      response = HTTParty.get(url)
      response.success? ? response : []
    rescue => e
      Rails.logger.error("API error: #{e.message}")
      []
    end
  end

  def authentication
    timestamp = Time.now.to_s
    hash_string = timestamp + ENV['MARVEL_PRIVATE_KEY'] + ENV['MARVEL_PUBLIC_KEY']
    hash = Digest::MD5.hexdigest(hash_string)

    {
      timestamp: timestamp,
      digest_hash: hash
    }
  end
end
