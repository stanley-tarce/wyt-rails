class SessionsController < ApplicationController

    def callback
      # @user = User.find_or_create_from_auth_hash(auth_hash)
      # self.current_user = @user
      # p auth_hash
      # p params.inspect.to_json
      # p params[:code]
      # p params[:state]
      render json: {info: auth_hash, }, status: :ok
    end
  
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
