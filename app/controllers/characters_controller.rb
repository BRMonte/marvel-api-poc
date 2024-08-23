class CharactersController < ApplicationController
  before_action :set_character, only: [:search]

  def search
  end

  private
  def set_character
    return unless params[:name]

    cache_key = "character_#{params[:name].downcase}"
    @character = Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      FetchCharacterService.new.call(params[:name])
    end
  end
end
