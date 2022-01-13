module Api
    class TeamsController < ApplicationController
        before_action :require_token
        before_action :check_token_expired?, only:[:index]
        before_action :authenticate_user!, only:[:index]

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


        def user_params
          params.permit(:league_key, :team_key, :player_keys)
        end
    end
end