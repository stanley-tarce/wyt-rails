module Api
    class TeamsController < ApplicationController
        before_action :require_token

        def leagues
          leagues = Yahoo::Client.leagues(@access_token)
      
          render json: leagues
        end

        def league
          league = Yahoo::Client.league(@access_token, user_params[:league_key])
      
          render json: league
        end

        def players
          players = Yahoo::Client.players(@access_token, user_params[:team_key])
      
          render json: players
        end

        def teams
          teams = Yahoo::Client.teams_in_league(@access_token, user_params[:league_key])
      
          render json: teams
        end

        def stats
          player_stats = Yahoo::Client.player_stats(@access_token, user_params[:league_key], user_params[:player_keys])
      
          render json: player_stats
        end

        private
        def require_token
          if request.headers['Authorization'] == nil 
            render json: { error: 'Unauthorized', status: 401 }, status: 401
          else 
            @access_token = request.headers['Authorization'].gsub("Bearer ","")
          end
        end

        def user_params
          params.permit(:league_key, :team_key, :player_keys)
        end
    end
end