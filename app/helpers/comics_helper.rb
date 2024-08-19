module ComicsHelper
  def comic_thumbnail(comic)
    return get_thumbnail(comic) if has_thumbnail?(comic)

    has_images?(comic) ? get_images(comic) : get_thumbnail(comic)
  end

  def is_favorite?(comic_id)
    session[:favorites].include?(comic_id.to_s)
  end

  private

  def has_thumbnail?(comic)
    return false unless comic.key?('thumbnail')
    !comic['thumbnail']['path'].include?('image_not_available')
  end

  def get_thumbnail(comic)
    return 'Not found' unless comic.key?('thumbnail')
    "#{comic['thumbnail']['path']}.#{comic['thumbnail']['extension']}"
  end

  def has_images?(comic)
    !comic['images'].empty?
  end

  def get_images(comic)
    return unless comic.key?('images')
    "#{comic['images']['path']}.#{comic['images']['extension']}"
  end

  def get_title(comic)
    return 'Not found' unless comic.key?('title')
    comic['title']
  end
end
