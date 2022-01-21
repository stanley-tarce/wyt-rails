class SessionsController < ApplicationController
    before_action :check_token, only: [:delete]
    prepend_before_action :authenticate_user!, only: [:delete]
    def callback
      if auth_hash
        full_name = "#{auth_hash['info']['first_name']} #{auth_hash['info']['last_name']}"
        User.create_with(full_name: full_name).find_or_create_by(email: auth_hash['info']['email']).update(access_token: auth_hash['credentials']['token'], refresh_token: auth_hash['credentials']['refresh_token'], expiry: auth_hash['credentials']['expires_at'],image: auth_hash['info']['image'])
        Session.create(user:User.find_by(email: auth_hash['info']['email']), token: auth_hash['credentials']['token'])
        redirect_to "http://localhost:3000/callback?token=#{Base64.encode64(auth_hash['credentials']['token'])}" 
      end
    end
    def delete
      Session.find_by_token(token).user.sessions.destroy_all
      User.find_by_access_token(token).update(access_token: nil, refresh_token: nil, expiry: nil)
      render json: { message: "User successfully logged out"}, status: :ok

    end
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
