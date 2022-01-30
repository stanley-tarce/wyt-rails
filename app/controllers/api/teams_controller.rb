# frozen_string_literal: true

module Api
  class TeamsController < ApplicationController
    before_action :check_token # Order
    prepend_before_action :authenticate_user!
    append_before_action :set_response_header
    include TradeHelper

    def roster_with_stats
      roster = roster_stats(user_params[:team_key], user_params[:league_key], token)
      player_info = roster[:roster]
      player_stats = roster[:stats]
      out = []
      player_info.each do |player|
         stat = begin
          player_stats.find do |stat|
            stat['player_key'] == player[:player_key]
          end.except('player_key')
        rescue StandardError
          player_stats.find do |stat|
            stat['player_key'] == player[:player_key]
          end
        end
        out << {  player_key: player[:player_key], player_name: player[:player_name], player_team_full: player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: stat}
      end
      rosters = { roster: out }
      render json: rosters, status: :ok
    rescue TypeError
      render json: { error: 'Unavailable to Fetch Roster' }, status: 400
    end

    # def roster_with_stats
    #   roster = Yahoo::Client.players(updated_token, user_params[:team_key])[:data][:players]
    #   roster_list = [] # Whole Roster with stats
    #   player_keys = [] # List of player_keys
    #   roster.map do |player|
    #     player_keys << player[:player_key].to_s
    #   end
    #   player_stats = Yahoo::Client.player_stats(updated_token, user_params[:league_key], player_keys.join(','))
    #   roster.each do |player|
    #     roster_list << { player_key: player[:player_key], player_name: player[:player_name], player_team_full: player[:player_team_full], player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: player_stats[:data][:player_stats].select do |stat|
    #                                                                                                                                                                                                                                                                                                                      stat['player_key'] == player[:player_key]
    #                                                                                                                                                                                                                                                                                                                    end [0].except('player_key') }
    #   end
    #   rosters = { roster: roster_list }
    #   render json: rosters, status: :ok
    # rescue TypeError
    #   render json: { error: 'Unavailable to Fetch Roster' }, status: 400
    # end
  end
end
