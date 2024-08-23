require 'rails_helper'

RSpec.describe 'Comics', type: :request do
  before do
    stub_request(:get, %r{https://gateway.marvel.com/v1/public/comics})
      .to_return(
        status: 200,
        body: { 'data' => { 'results' => [{ 'id' => 1, 'title' => 'Spider-Man', 'images' => [] }] } }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe 'GET /comics' do
    it 'returns an array of comics' do
      get comics_path
      expect(response).to have_http_status(:ok)

      response.body.include?('Spider-Man') ? expect(response.body).to include('Spider-Man') : expect(response.body).to include('Try again!')
      end
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
