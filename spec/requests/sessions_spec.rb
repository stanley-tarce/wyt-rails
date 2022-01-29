# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Sessions', type: :request, vcr: true do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
  end

  context 'Yahoo Auth and Callback' do
    it '1. It should return a hash value' do
      expect(request.env['omniauth.auth']).to be_a(Hash)
    end

    it '2. It should return a 204 no content response' do
      expect(response).to have_http_status(:no_content)
    end

    it '3. It should logout the user' do
      delete '/auth/yahoo_auth/logout', headers: { 'Authorization': "Bearer #{@token}" }
      expect(response).to have_http_status(:ok)
    end
  end
end
