module ComicsHelper
  def is_favorite?(comic_id)
    session[:favorites].include?(comic_id.to_s)
  end
end
