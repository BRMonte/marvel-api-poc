class FetchComicBooksService
  require 'httparty'
  require 'digest'

  include MarvelApi

  def call
    marvel_api
  end

  private

  def marvel_api
    ts, digest_hash, key = MarvelApi.credentials.values_at(:timestamp, :digest_hash, :api_key)
    url = "#{MarvelApi::BASE_URL}#{MarvelApi.endpoint(:comics)}?ts=#{ts}&apikey=#{key}&hash=#{digest_hash}"

    begin
      response = HTTParty.get(url)
      response.success? ? response : []
    rescue => e
      Rails.logger.error("API error: #{e.message}")
      []
    end
  end
end
