# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'Teams', type: :request do
  before(:each) do
    Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
    get '/auth/yahoo_auth/callback'
    @token = request.env['omniauth.auth'][:credentials][:token]
    get '/api/leagues', headers: { 'Authorization': "Bearer #{@token}" }
  end
  context '/api/trades **with Bearer Token' do
    it '1. It should return a 200 response' do
        get "/api/trades?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}" }
        expect(response).to have_http_status(200)
    end
    it '2. It should create a Trade Model' do
         get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        expect(response).to have_http_status(200)
    end
    it '3. It should show a trade info' do
        get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        get "/api/trades/#{User.first.leagues.first.trades.first.id}"
        expect(response).to have_http_status(200)
    end
    it "4. It should update a trade" do
               get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        update = {
            players_to_send: [
                {player_key: @user_roster[@user_roster.length-3]['player_key'], player_name: @user_roster[@user_roster.length-3]['player_name']},
                {player_key: @user_roster[@user_roster.length-2]['player_key'], player_name: @user_roster[@user_roster.length-2]['player_name']}],
            players_to_receive: [
                {player_key: @partner_roster[@partner_roster.length-3],player_name: @partner_roster[@partner_roster.length-3]},
                {player_key: @partner_roster[@partner_roster.length-2],player_name: @partner_roster[@partner_roster.length-2]}]
        }
        patch "/api/trades/#{User.first.leagues.first.trades.first.id}", params: update, headers: { 'Authorization': "Bearer #{@token}" }
        expect(response).to have_http_status(200)
    end
    it "5. It should delete a trade" do
          get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        delete "/api/trades/#{User.first.leagues.first.trades.first.id}", headers: { 'Authorization': "Bearer #{@token}"}
        expect(response).to have_http_status(200)
    end
  end
  context '/api/trades **without Bearer Token' do
    it '1. It should return a 401 response' do
        get "/api/teams?league_key=#{User.first.leagues.first.league_key}"
        expect(response).to have_http_status(401)
    end
    it '2. It should return a 401 response in create trade' do
          get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data
        expect(response).to have_http_status(401)
  end
  it '3. It should return a 401 response when updating a trade' do
                   get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        update = {
            players_to_send: [
                {player_key: @user_roster[@user_roster.length-3]['player_key'], player_name: @user_roster[@user_roster.length-3]['player_name']},
                {player_key: @user_roster[@user_roster.length-2]['player_key'], player_name: @user_roster[@user_roster.length-2]['player_name']}],
            players_to_receive: [
                {player_key: @partner_roster[@partner_roster.length-3],player_name: @partner_roster[@partner_roster.length-3]},
                {player_key: @partner_roster[@partner_roster.length-2],player_name: @partner_roster[@partner_roster.length-2]}]
        }
        patch "/api/trades/#{User.first.leagues.first.trades.first.id}", params: update
        expect(response).to have_http_status(401)
  end
  it '4. It should return a 401 response when deleting a trade' do 
              get "/api/teams?league_key=#{User.first.leagues.first.league_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @teams = JSON.parse(response.body)['league_teams']
         get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{User.first.leagues.first.team_key}", headers: { 'Authorization': "Bearer #{@token}"}
         @user_roster = JSON.parse(response.body)['roster']
        get "/api/roster_with_stats?league_key=#{User.first.leagues.first.league_key}&team_key=#{@teams.first['team_key']}", headers: { 'Authorization': "Bearer #{@token}"}
        @partner_roster = JSON.parse(response.body)['roster']
        @data = {
            trade: {
                team_key: @teams.first['team_key'],
                team_name: @teams.first['team_name'],
                team_logo: @teams.first['team_logo_url']
            },
            players_to_send: [
                { player_key: @user_roster.first['player_key'], player_name: @user_roster.first['player_name'] },
                { player_key: @user_roster.second['player_key'], player_name: @user_roster.second['player_name'] },
            ],
            players_to_receive: [
                { player_key: @partner_roster.first['player_key'], player_name: @partner_roster.first['player_name']},
                { player_key: @partner_roster.second['player_key'], player_name: @partner_roster.second['player_name']}
            ]
        }
        post "/api/create_trade?league_key=#{User.first.leagues.first.league_key}", params: @data, headers: { 'Authorization': "Bearer #{@token}" }
        delete "/api/trades/#{User.first.leagues.first.trades.first.id}"
        expect(response).to have_http_status(401)
    end
end
end
