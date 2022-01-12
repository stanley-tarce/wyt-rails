module Api
    class TeamsController < ApplicationController
        before_action :require_token
        before_action :check_token_expired?, only:[:index]
        before_action :authenticate_user!, only:[:index]

        def index
        teams = Yahoo::Client.teams(require_token)
        render json: teams
        end

        private

        def leagues
          leagues = Yahoo::Client.leagues(@access_token)
      
          render json: leagues
        end

        def league
          league = Yahoo::Client.league(@access_token, user_params[:league_key])
      
          render json: league
        end

        private


        def user_params
          params.permit(:league_key)
        end
    end
end