# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
  end

  context '/user *with Bearer Token', vcr: true do
    it '1. It should get a 200 response' do
      get '/user', headers: { 'Authorization': "Bearer #{@token}" }
      expect(response).to have_http_status(:ok)
    end

    it '2. It should have an email in the response' do
      get '/user', headers: { 'Authorization': "Bearer #{@token}" }
      expect(JSON.parse(response.body)['email']).to eq(User.first.email)
    end

    it '3. It should have an image in the response' do
      get '/user', headers: { 'Authorization': "Bearer #{@token}" }
      expect(JSON.parse(response.body)['image']).to eq(User.first.image)
    end

    it '4. It should have a full_name in the response' do
      get '/user', headers: { 'Authorization': "Bearer #{@token}" }
      expect(JSON.parse(response.body)['full_name']).to eq(User.first.full_name)
    end
  end

  context '/user *without Bearer Token', vcr: true do
    it '1. It should get a 401 response' do
      get '/user'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
