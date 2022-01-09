class SessionsController < ApplicationController

    def callback
      if auth_hash
        puts auth_hash['credentials']['token']
        @user = User.create_with(access_token: auth_hash['credentials']['token']).find_or_create_by(email: auth_hash['info']['email'])

        
        # @user = User.find_or_create_by!(email: auth_hash['info']['email']).update!(access_token: auth_hash['info']['token'])
        @user['full_name'] == auth_hash['info']['first_name'] + ' ' + auth_hash['info']['last_name'] unless User.find_by(email: auth_hash['info']['email']) != nil
        # self.current_user = @users
        puts @user.inspect
        redirect_to '/'
      else 
        render json: { error: "error"}, status: 401
      # render json: {info: auth_hash}, status: :ok
      end
    end
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
