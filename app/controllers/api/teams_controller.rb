module Api
    class TeamsController < ApplicationController
        def index
        teams = Yahoo::Client.teams(require_token)
        render json: teams
        end
        private
    end
end