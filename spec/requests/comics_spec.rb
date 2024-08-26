require 'rails_helper'

RSpec.describe 'Comics', type: :request do
  let(:response_body) do
    { 'data' => { 'results' => [{ 'id' => 1, 'title' => 'Spider-Man', 'images' => [] }] } }
  end

  let(:comics_response) { instance_double(HTTParty::Response, body: response_body, success?: true) }

  before do
    allow(HTTParty).to receive(:get).and_return(response_body)
  end

  describe 'GET /comics' do
    it 'returns an array of comics' do
      get comics_path
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['results'].first['title']).to eq('Spider-Man')
    end
  end

  describe 'PATCH /comics/:id/favorite' do
    let(:comic_id) { "1" }

    context 'when adding a comic to favorites' do
      before do
        patch favorite_comic_path(comic_id)
      end

      it 'adds the comic to favorites' do
        expect(session[:favorites]).to include(comic_id)
      end
    end

    context 'when removing a comic from favorites' do
      before do
        patch favorite_comic_path(comic_id)
        patch favorite_comic_path(comic_id)
      end

      it 'removes the comic from favorites' do
        expect(session[:favorites]).not_to include(comic_id)
      end
    end
  end
end
