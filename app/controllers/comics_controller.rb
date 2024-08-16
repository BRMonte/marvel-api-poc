class ComicsController < ApplicationController
  def index
    @comics = params[:search].present? ? filter_results(results, params[:search]) : results
    @comics = Kaminari.paginate_array(@comics).page(params[:page]).per(10)
  end

  private

  def filter_results(results, term)
    sanitized_term = term.downcase
    filtered_results = []

    results.each do |comic|
      if comic['title'].downcase.include?(sanitized_term)
        filtered_results << comic
      else
        next if comic['characters']['items'].empty?

        characters_names = comic['characters']['items'].map { |character| character['name'].downcase }
        filtered_results << comic if characters_names.any? { |name| name.include?(sanitized_term) }
      end
    end

    filtered_results
  end

  def results
    Rails.cache.fetch('comics_data', expires_in: 1.day) do
      marvel_service = MarvelApiService.new
      marvel_service.call['data']['results']
    end
  end
end
