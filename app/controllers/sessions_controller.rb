class SessionsController < ApplicationController

    def callback
      if auth_hash
        # @user = User.create_with(access_token: auth_hash['credentials']['token']).find_or_create_by(email: auth_hash['info']['email'])
        full_name = "#{auth_hash['info']['first_name']} #{auth_hash['info']['last_name']}"
        User.create_with(full_name: full_name).find_or_create_by(email: auth_hash['info']['email']).update(access_token: auth_hash['credentials']['token'])

        #Alex, basically this will find the user first and if it can't find the user then it will create a new user with the full_name included. And then, it will update the access token for the user.  https://apidock.com/rails/v4.0.2/ActiveRecord/Relation/find_or_create_by
        

        # @user = User.find_or_create_by!(email: auth_hash['info']['email']).update!(access_token: auth_hash['info']['token'])
        # @user['full_name'] == auth_hash['info']['first_name'] + ' ' + auth_hash['info']['last_name'] unless User.find_by(email: auth_hash['info']['email']) != nil
        # self.current_user = @users
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
