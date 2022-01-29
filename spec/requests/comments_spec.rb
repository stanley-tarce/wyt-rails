# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Comments', type: :request, vcr: true do
  before do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
    get '/api/leagues', headers: { 'Authorization': "Bearer #{@token}" }
  end

  context 'with valid Attributes' do
    it '1. It should get all comments inside a trade' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @teams = JSON.parse(response.body)['league_teams']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @user_roster = JSON.parse(response.body)['roster']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @partner_roster = JSON.parse(response.body)['roster']
      @data = {
        trade: {
          team_key: @teams.first['team_key'],
          team_name: @teams.first['team_name'],
          team_logo: @teams.first['team_logo_url']
        },
        players_to_send: [
          { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
          { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] }
        ],
        players_to_receive: [
          { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name'] },
          { player_key: @partner_roster.second['player_key'],
            player_name: @partner_roster.second['player_name'] }
        ]
      }
      post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data,
                                                                                  headers: { 'Authorization': "Bearer #{@token}" }
      get "/api/trades/#{User.first.leagues.first.trades.first.id}/comments"
      expect(response).to have_http_status(:ok)
    end

    it '2. It should create a comment' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @teams = JSON.parse(response.body)['league_teams']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @user_roster = JSON.parse(response.body)['roster']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @partner_roster = JSON.parse(response.body)['roster']
      @data = {
        trade: {
          team_key: @teams.first['team_key'],
          team_name: @teams.first['team_name'],
          team_logo: @teams.first['team_logo_url']
        },
        players_to_send: [
          { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
          { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] }
        ],
        players_to_receive: [
          { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name'] },
          { player_key: @partner_roster.second['player_key'],
            player_name: @partner_roster.second['player_name'] }
        ]
      }
      post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data,
                                                                                  headers: { 'Authorization': "Bearer #{@token}" }
      post "/api/trades/#{User.first.leagues.first.trades.first.id}/comments",
           params: { comment: { name: 'Test', description: 'Test 123',
                                trade_id: User.first.leagues.first.trades.first.id } }
      expect(response).to have_http_status(:created)
    end

    it '3. It should update a comment' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @teams = JSON.parse(response.body)['league_teams']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @user_roster = JSON.parse(response.body)['roster']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @partner_roster = JSON.parse(response.body)['roster']
      @data = {
        trade: {
          team_key: @teams.first['team_key'],
          team_name: @teams.first['team_name'],
          team_logo: @teams.first['team_logo_url']
        },
        players_to_send: [
          { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
          { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] }
        ],
        players_to_receive: [
          { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name'] },
          { player_key: @partner_roster.second['player_key'],
            player_name: @partner_roster.second['player_name'] }
        ]
      }
      post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data,
                                                                                  headers: { 'Authorization': "Bearer #{@token}" }
      post "/api/trades/#{User.first.leagues.first.trades.first.id}/comments",
           params: { comment: { name: 'Test', description: 'Test 123',
                                trade_id: User.first.leagues.first.trades.first.id } }
      patch "/api/trades/#{User.first.leagues.first.trades.first.id}/comments/#{User.first.leagues.first.trades.first.comments.first.id}",
            params: { comment: { name: 'Stanley Test', description: 'Test 12323233232322' } }
      expect(response).to have_http_status(:ok)
    end

    it '4. It should delete a comment' do
      get "/api/teams?league_key=#{User.first.leagues.first.league_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @teams = JSON.parse(response.body)['league_teams']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @user_roster = JSON.parse(response.body)['roster']
      get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}",
          headers: { 'Authorization': "Bearer #{@token}" }
      @partner_roster = JSON.parse(response.body)['roster']
      @data = {
        trade: {
          team_key: @teams.first['team_key'],
          team_name: @teams.first['team_name'],
          team_logo: @teams.first['team_logo_url']
        },
        players_to_send: [
          { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
          { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] }
        ],
        players_to_receive: [
          { player_key: @partner_roster.first['player_key'],
            player_name: @partner_roster.first['player_name'] },
          { player_key: @partner_roster.second['player_key'],
            player_name: @partner_roster.second['player_name'] }
        ]
      }
      post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data,
                                                                                  headers: { 'Authorization': "Bearer #{@token}" }
      post "/api/trades/#{User.first.leagues.first.trades.first.id}/comments/",
           params: { comment: { name: 'Test', description: 'Test 123',
                                trade_id: User.first.leagues.first.trades.first.id } }
      delete "/api/trades/#{User.first.leagues.first.trades.first.id}/comments/#{User.first.leagues.first.trades.first.comments.first.id}"
      expect(response).to have_http_status(:ok)
    end
  end
  # context '/leagues **without Bearer Token' do
  #   it '1. It should return a 401 response' do
  #     get '/api/leagues'
  #     expect(response).to have_http_status(401)
  #   end
  # end
end
