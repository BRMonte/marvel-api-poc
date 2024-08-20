require 'rails_helper'
require 'webmock/rspec'

RSpec.describe FetchComicBooksService, type: :service do
  let(:marvel_url) { 'https://gateway.marvel.com' }
  let(:service) { described_class.new }

  describe '#call' do
    context 'when the API request is successful' do
      before do
        stub_request(:get, marvel_url)
          .to_return(status: 200, body: { 'data' => { 'results' => [{ 'id' => 1, 'title' => 'Spider-Man' }] } }.to_json)
      end

      it 'returns the comics data' do
        allow(service).to receive(:marvel_api).and_return({ 'data' => { 'results' => [{ 'id' => 1, 'title' => 'Spider-Man' }] } })

        response = service.call
        expect(response['data']['results'].first['title']).to eq('Spider-Man')
      end
    end

    context 'when the API request fails' do
      before do
        stub_request(:get, marvel_url)
          .to_return(status: 500, body: { 'error' => 'Internal Server Error' }.to_json)
      end

      it 'returns an empty array' do
        allow(service).to receive(:marvel_api).and_return([])

        response = service.call
        expect(response).to eq([])
      end
    end
  end
end
