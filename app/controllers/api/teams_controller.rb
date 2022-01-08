module Api
    class TeamsController < ApplicationController
    
        def index
        teams = Yahoo::Client.teams(require_token)
    
        render json: teams
        end

        private
        def require_token
          if request.authorization == nil
            render json: { error: 'Unauthorized', status: 401 }, status: 401
          end
        end
    end
end