class ComicsController < ApplicationController

  def index
    session[:favorites] ||= []

    @comics = results
    @comics = paginate(@comics)
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

  def results
    cached_results = Rails.cache.read('comics_data')
    return cached_results if cached_results

    marvel_service = FetchComicBooksService.new.call
    return marvel_service if marvel_service.kind_of?(Array) && marvel_service.empty?

    Rails.cache.write('comics_data', marvel_service, expires_in: 1.day)
    results
  end
end
