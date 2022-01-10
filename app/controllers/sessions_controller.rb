class SessionsController < ApplicationController

    def callback
      if auth_hash
        full_name = "#{auth_hash['info']['first_name']} #{auth_hash['info']['last_name']}"
        User.create_with(full_name: full_name).find_or_create_by(email: auth_hash['info']['email']).update(access_token: auth_hash['credentials']['token'])
        create
      else 
        render json: { error: "error"}, status: 401
      end
    end
    def create
      session['user_id'] = User.find_by_email(auth_hash['info']['email']).id
      render json: { message: "User successfully logged in"}, status: :ok
      redirect_to '/'
    end
    def delete
      session['user_id'] = nil
      current_user.update(access_token: nil, refresh_token: nil, expiry: nil) #remove access tokens from db
      render json: { message: "User successfully logged out"}, status: :ok

    end
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
