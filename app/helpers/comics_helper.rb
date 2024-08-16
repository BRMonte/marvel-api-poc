module ComicsHelper
  def comic_thumbnail(comic)
    "#{comic['thumbnail']['path']}.#{comic['thumbnail']['extension']}"
  end
end
