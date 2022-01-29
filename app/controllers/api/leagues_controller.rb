# frozen_string_literal: true

module Api
  class LeaguesController < ApplicationController
    before_action :check_token # Order
    prepend_before_action :authenticate_user!
    append_before_action :set_response_header
    protect_from_forgery with: :null_session
    def index
      leagues = Yahoo::Client.leagues(updated_token)
      if leagues[:data]
        teams = []
        leagues[:data][:teams].each do |team|
          roster = Yahoo::Client.players(updated_token, team[:team_key])[:data][:players]
          league_key = team[:team_key].split('.')[0..2].join('.')
          league = Yahoo::Client.league(updated_token, league_key)
          current_user.leagues.create_with(team_key: team[:team_key],
                                           team_name: team[:team_name]).find_or_create_by(league_key: league_key).update(league_name: league[:data][:league][:league_name])
          if roster.count != 0
            teams << { league_key: league_key, league_name: league[:data][:league][:league_name],
                       scoring_type: league[:data][:league][:scoring_type], num_teams: league[:data][:league][:num_teams], team: { team_key: team[:team_key], team_name: team[:team_name], logo_url: team[:logo_url] }, roster_positions: league[:data][:league][:roster_postions] }
          end
        end
        render json: teams, status: :ok
      else
        render json: { message: 'No Leagues Found' }, status: :ok
      end
    end
  end
end
