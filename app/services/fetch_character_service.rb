class FetchCharacterService
  require 'httparty'
  require 'digest'
  include MarvelApi

  def call(name)
    fetch_character(name)
  end

  private

  def fetch_character(name)
    ts, digest_hash, key = MarvelApi.credentials.values_at(:timestamp, :digest_hash, :api_key)
    url = "#{MarvelApi::BASE_URL}#{MarvelApi.endpoint(:characters)}?name=#{name.to_s}&ts=#{ts}&apikey=#{key}&hash=#{digest_hash}"

    begin
      response = HTTParty.get(url)

      response.success? ? CharacterParserService.new(response) : []
    rescue => e
      Rails.logger.error("API error: #{e.message}")
      []
    end
  end
end
