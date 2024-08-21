class ComicsController < ApplicationController
  def index
    session[:favorites] ||= []

    @comics = results()
    @comics = filter_results(@comics, params[:search])
    @comics = paginate(@comics)
  end

  def characters
    return unless params[:name]

    cache_key = "character_#{params[:name].downcase}"
    @character = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      FetchCharacterService.new.call(params[:name])
    end
  end

  def favorite
    session[:favorites] ||= []
    id = params[:id]

    session[:favorites].include?(id) ? session[:favorites].delete(id) : session[:favorites] << id

    head :ok
  end

  private

  def paginate(comics)
    page = [params[:page].to_i, 1].max
    per_page = 10

    WillPaginate::Collection.create(page.to_i, per_page, comics.size) do |pager|
      pager.replace comics[pager.offset, pager.per_page]
    end
  end

  def filter_results(results, term)
    return results if results.empty? || term.nil? || term.strip == ''

    sanitized_term = term.downcase
    filtered_results = []

    results.each do |comic|
      if comic['title'].downcase.include?(sanitized_term)
        filtered_results << comic
      else
        next if comic['characters']['items'].empty?

        characters_names = comic['characters']['items'].map { |c| c['name'].downcase }
        filtered_results << comic if characters_names.any? { |name| name.include?(sanitized_term) }
      end
    end

    filtered_results
  end

  def results
    cached_results = Rails.cache.read('comics_data')
    return cached_results if cached_results

    marvel_service = FetchComicBooksService.new.call
    return marvel_service if marvel_service.kind_of?(Array) && marvel_service.empty?

    results = marvel_service['data']['results']
    Rails.cache.write('comics_data', results, expires_in: 1.day)
    results
  end
end
