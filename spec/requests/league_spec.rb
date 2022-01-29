# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Leagues', type: :request, vcr: true do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
    get '/api/leagues', headers: { 'Authorization': "Bearer #{@token}" }
  end

  context '/leagues **with Bearer Token' do
    it '1. It should return a 200 response' do
      expect(response).to have_http_status(:ok)
    end

    it '2. It should have a League Model after running the api' do
      expect(User.first.leagues.count).to eq(JSON.parse(response.body).count)
    end

    it '3. It should have a league_key in the response' do
      expect(JSON.parse(response.body).first['league_key']).to be_a(String)
    end
  end

  context '/leagues **without Bearer Token' do
    it '1. It should return a 401 response' do
      get '/api/leagues'
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
