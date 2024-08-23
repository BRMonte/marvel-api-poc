require 'rails_helper'
require 'webmock/rspec'

RSpec.describe 'Characters', type: :request do
  let(:name) { 'Hulk' }
  let(:character_response) do
    {
      'data' => {
        'results' => [
          {
            'id' => 1,
            'name' => name,
            'description' => 'Some description',
            'thumbnail' => {
              'path' => 'thumbnail_path',
              'extension' => 'jpg'
            }
          }
        ]
      }
    }
  end

  before do
    stub_request(:get, /#{Regexp.quote(MarvelApi::BASE_URL)}.*characters/)
      .to_return(status: 200, body: character_response.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  describe 'GET /characters/search' do
    context 'with name parameter' do
      before { get search_characters_path, params: { name: name } }

      it 'returns a successful response' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns character with that name if it exists' do
        expect(response.body).to include(name)
      end
    end
  end
end
