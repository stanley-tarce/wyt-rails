module Api
    class TeamsController < ApplicationController

        before_action :check_token #Order 
        prepend_before_action :authenticate_user!
        append_before_action :set_response_header
        protect_from_forgery with: :null_session

        def leagues
          leagues = Yahoo::Client.leagues(updated_token)
          render json: leagues
        end

        def league
          league = Yahoo::Client.league(updated_token, user_params[:league_key])
      
          render json: league
        end

        def players
          params.inspect
          players = Yahoo::Client.players(updated_token, user_params[:team_key])
      
          render json: players
        end

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

        private



    end
end