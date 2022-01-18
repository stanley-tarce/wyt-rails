module Api
    class TeamsController < ApplicationController
        before_action :check_token #Order 
        prepend_before_action :authenticate_user!
        append_before_action :set_response_header
        protect_from_forgery with: :null_session

        # def leagues
        #   leagues = Yahoo::Client.leagues(updated_token)
        #   render json: leagues
        # end

        # def league
        #   league = Yahoo::Client.league(updated_token, user_params[:league_key])
      
        #   render json: league
        # end

        # def players
        #   params.inspect
        #   players = Yahoo::Client.players(updated_token, user_params[:team_key])
      
        #   render json: players
        # end

        def teams
          teams = Yahoo::Client.teams_in_league(updated_token, user_params[:league_key])
          if teams[:code] != 200
            return render json: { error: 'Invalid League Key' }, status: 400
          else
            return render json: teams
          end
        end

        def stats
          player_stats = Yahoo::Client.player_stats(updated_token, user_params[:league_key], user_params[:player_keys])
      
          render json: player_stats
        end

        def roster_with_stats
          roster = Yahoo::Client.players(updated_token, user_params[:team_key])[:data][:players]
          roster_list = [] #Whole Roster with stats
          player_keys = [] #List of player_keys
          roster.map do |player|
            player_keys << player[:player_key].to_s
          end
          player_stats = Yahoo::Client.player_stats(updated_token, user_params[:league_key], player_keys.join(","))
          roster.each do |player|
            roster_list << { player_key: player[:player_key], player_name: player[:player_name], player_team_full: player[:player_team_full],player_team_abbr: player[:player_team_abbr], player_number: player[:player_number], player_positions: player[:player_positions], player_image: player[:player_image], stats: player_stats[:data][:player_stats].select{ |stat| stat['player_key'] == player[:player_key] }[0] }
          end
          rosters =  { roster: roster_list }
          render json: rosters
        end 
        private
    end
end