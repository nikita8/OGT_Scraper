require 'rails_helper'

describe StoriesController do
  describe 'POST stories' do
    # Happy Path
    context 'When the url is present' do
      let(:random_id) { 'some-random-id' }
      let(:url) { 'www.example.com' }

      before do
        allow(Story).to receive(:create).with(url).and_return(random_id)
      end

      it 'returns response as ok' do
        post :create, params: {url: url}
        expect(response).to have_http_status(:ok)
      end

      it 'returns id representing url' do
        post :create, params: {url: url}
        expect(parsed(response)['id']).to eql(random_id)
      end
    end

    context 'When the url is missing' do
      it 'returns response as bad_request' do
        post :create
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns error status as response body' do
        post :create
        expect(parsed(response)['status']).to eql('error')
      end

      it 'returns error message as response body' do
        post :create
        expect(parsed(response)['message']).to eql("'url' is missing")
      end
    end

    context 'When the url is present but there is an error while saving the record' do
      let(:url) { 'www.example.com' }

      before do
        allow(Story).to receive(:create).with(url).and_return(nil)
      end

      it 'returns response as internal server error' do
        post :create, params: { url: url }
        expect(response).to have_http_status(:internal_server_error)
      end

      it 'returns error message as response body' do
        post :create, params: { url: url }
        expect(parsed(response)['message']).to eql("Something went wrong")
      end
    end
  end

  describe 'GET stories' do
    let(:random_id) { 'some-random-id' }

    # Happy Path
    context 'When id is present' do
      it 'returns response code as 200' do
        expect(Story).to receive(:find).with(random_id).and_return(random_id)

        get :show, params: { id: random_id }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'When id is not present in the data-store' do
      it 'returns response code as 404' do
        expect(Story).to receive(:find).with(random_id).and_return(nil)

        get :show, params: { id: random_id }

        expect(response).to have_http_status(:not_found)
      end

      it 'returns response message accordingly' do
        expect(Story).to receive(:find).with(random_id).and_return(nil)

        get :show, params: { id: random_id }

        expect(parsed(response)['message']).to eql('Resource not found')
      end
    end
  end
end

def parsed(res)
  JSON.parse(res.body)
end
