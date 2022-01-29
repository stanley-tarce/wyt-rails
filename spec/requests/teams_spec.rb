# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Teams', type: :request do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
    get '/api/leagues', headers: { 'Authorization': "Bearer #{@token}" }
  end

  context '/api/teams **with Bearer Token', vcr: true do
    it '1. It should return a 200 response' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      expect(response).to have_http_status(:ok)
    end
  end

  context '/api/teams **without Bearer Token', vcr: true do
    it '1. It should return a 401 response' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}"
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
