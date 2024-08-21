class CharacterParserService
  attr_reader :id, :name, :description, :thumbnail, :success, :message

  def initialize(response_body)
    @result = response_body['data']['results'].empty? ? [] : response_body['data']['results'].first
    parsed_response
  end

  private

  def parsed_response
    @id = @result.empty? ? 'Not found' : @result['id']
    @name = @result.empty? ? 'Not found' : @result['name']
    @description = @result.empty? ? 'Not found' : @result['description']
    @thumbnail = @result.empty? ? 'Not found' : "#{@result['thumbnail']['path']}.#{@result['thumbnail']['extension']}"
    @message = @result.empty? ? 'Character not available' : 'Success'
    @success = !@result.empty?
  end
end
