class ComicsController < ApplicationController
  def index
    @comics = MarvelApiService.new.call['data']['results']
  end

  def show
  end
end
