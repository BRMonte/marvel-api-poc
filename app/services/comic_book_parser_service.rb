class ComicBookParserService
  attr_reader :id, :title, :thumbnail

  def initialize(comic)
    @comic = comic
  end

  def parse
    parse_response
  end

  private
  def parse_response
    {
      id: @comic['id'].to_s,
      title: @comic['title'],
      thumbnail: "#{@comic['thumbnail']['path']}.#{@comic['thumbnail']['extension']}"
    }
  end
end
