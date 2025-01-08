require 'rails_helper'

RSpec.describe Api::UrlsController, type: :controller do
  before do
    ahoy_tracker = instance_double(Ahoy::Tracker)
    allow(controller).to receive(:ahoy).and_return(ahoy_tracker)
    allow(ahoy_tracker).to receive(:track)

    request.headers['Authorization'] = 'Basic ' + Base64.encode64('admin:password')
  end

  let!(:url) { create(:url, long_url: 'https://www.example.com') }
  let(:valid_attributes) { { long_url: 'https://www.example.com' } }
  let(:invalid_attributes) { { long_url: 'invalid-url' } }

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new URL' do
        expect {
          post :create, params: { url: valid_attributes }
        }.to change(Url, :count).by(1)
      end

      it 'returns the short_url and long_url' do
        post :create, params: { url: valid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response['short_url']).to be_present
        expect(json_response['long_url']).to eq(valid_attributes[:long_url])
      end

      it 'responds with status created' do
        post :create, params: { url: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid params' do
      it 'does not create a new URL' do
        expect {
          post :create, params: { url: invalid_attributes }
        }.to_not change(Url, :count)
      end

      it 'returns an error message' do
        post :create, params: { url: invalid_attributes }
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to include('Long url is invalid')
      end

      it 'responds with status unprocessable entity' do
        post :create, params: { url: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET #index' do
    it 'returns a list of all URLs' do
      get :index
      json_response = JSON.parse(response.body)
      expect(json_response).to be_an(Array)
      expect(json_response.first['long_url']).to eq(url.long_url)
    end

    it 'responds with status ok' do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #show' do
    context 'when URL exists' do
      it 'returns the URL details' do
        get :show, params: { id: url.short_url }
        json_response = JSON.parse(response.body)
        expect(json_response['long_url']).to eq(url.long_url)
        expect(json_response['short_url']).to eq(url.short_url)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when URL does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 'nonexistent' }
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Could not find URL!!')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #redirect_short_url' do
    context 'when URL exists and is active' do
      it 'increments the click count and redirects to the long URL' do
        expect {
          get :redirect_short_url, params: { short_url: url.short_url }
        }.to change { url.reload.clicks }.by(1)

        expect(response).to redirect_to(url.long_url)
      end
    end

    context 'when URL does not exist or is expired' do
      it 'returns an error' do
        get :redirect_short_url, params: { short_url: 'expired-url' }
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Could not find URL or it has expired!!')
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'GET #analytics' do
    context 'when URL exists' do
      it 'returns analytics for the URL' do
        ahoy.track 'Visited shortened URL'

        get :analytics, params: { long_url: url.long_url }
        json_response = JSON.parse(response.body)
        expect(json_response['total_visits']).to eq(1)
        expect(json_response['browsers']).to be_a(Hash)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when URL does not exist' do
      it 'returns a not found error' do
        get :analytics, params: { long_url: 'nonexistent-url' }
        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Could not find URL!!')
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
