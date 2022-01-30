# frozen_string_literal: true

module Api
  class TeamsController < ApplicationController
    before_action :check_token # Order
    prepend_before_action :authenticate_user!
    append_before_action :set_response_header
    include TradeHelper
    def teams
      teams = Yahoo::Client.teams_in_league(updated_token, user_params[:league_key])
      if teams[:code] != 200
        render json: { error: 'Invalid League Key' }, status: 400
      else
        render json: teams[:data], status: :ok
      end
    end

    def roster_with_stats
      roster = roster_stats(user_params[:team_key], user_params[:league_key], token)
      rosters = { roster: organized_default_roster(roster) }
      render json: rosters, status: :ok
    rescue TypeError
      render json: { error: 'Unavailable to Fetch Roster' }, status: 400
    end
  end
end
