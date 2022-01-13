class SessionsController < ApplicationController
    def callback
      if auth_hash
        full_name = "#{auth_hash['info']['first_name']} #{auth_hash['info']['last_name']}"
        User.create_with(full_name: full_name).find_or_create_by(email: auth_hash['info']['email']).update(access_token: auth_hash['credentials']['token'], refresh_token: auth_hash['credentials']['refresh_token'], expiry: auth_hash['credentials']['expires_at'])
        Session.create(user:User.find_by(email: auth_hash['info']['email']), token: auth_hash['credentials']['token'])
        token = {access_token: auth_hash['credentials']['token'], refresh_token: auth_hash['credentials']['refresh_token'], expiry: auth_hash['credentials']['expires_at']} #save access token to cookie
        cookies.signed[:access_token] = {value: auth_hash['credentials']['token'], expires: 72.hour, domain: 'https://stock-app-react.vercel.app' }
        redirect_to 'https://stock-app-react.vercel.app/'
        
      else 
        redirect_to 'www.front-end-url.com', alert: 'Unable to sign in with Yahoo.'
      end
    end
    def delete
      # current_user.update(access_token: nil, refresh_token: nil, expiry: nil) #remove access tokens from db
      # Session.where(user_id: )
      Session.find_by(token: cookies.signed[:access_token]).user.sessions.destroy_all
      User.find_by_access_token(cookies.signed[:access_token]).update(access_token: nil, refresh_token: nil, expiry: nil)
      cookies.delete(:access_token) #remove access token from cookie
      render json: { message: "User successfully logged out"}, status: :ok

    end
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
