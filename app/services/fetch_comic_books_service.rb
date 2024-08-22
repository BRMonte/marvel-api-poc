class FetchComicBooksService
  require 'httparty'
  require 'digest'

  include MarvelApi

  FALLBACK = []

  def call
    fetch_comics
  end

  private

  def fetch_comics
    ts, digest_hash, key = MarvelApi.credentials.values_at(:timestamp, :digest_hash, :api_key)
    url = "#{MarvelApi::BASE_URL}#{MarvelApi.endpoint(:comics)}?ts=#{ts}&apikey=#{key}&hash=#{digest_hash}"

    begin
      response = HTTParty.get(url)
      handle_response(response)
    rescue => e
      Rails.logger.error("API error: #{e.message}")
      FALLBACK
    end
  end

  def handle_response(response)
    if response.success?
      results = response['data']['results']

      results.map { |c| ComicBookParserService.new(c).parse }
    else
      FALLBACK
    end
  end
end
