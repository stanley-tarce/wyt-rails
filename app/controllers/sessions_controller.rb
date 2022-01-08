class SessionsController < ApplicationController

    def callback
      @user = User.create_with(access_token: auth_hash['credentials']['token']).find_or_create_by(email: auth_hash['info']['info']['email'])
      # self.current_user = @user
      redirect_to '/'
      # render json: {info: auth_hash}, status: :ok
    end
  
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
