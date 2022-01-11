module Api
    class TeamsController < ApplicationController
        before_action :require_token

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
        def require_token
          if request.headers['Authorization'] == nil 
            render json: { error: 'Unauthorized', status: 401 }, status: 401
          else 
            @access_token = request.headers['Authorization'].gsub("Bearer ","")
          end
        end

        def user_params
          params.permit(:league_key)
        end
    end
end