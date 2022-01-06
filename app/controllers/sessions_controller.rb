class SessionsController < ApplicationController

    skip_before_action :verify_authenticity_token, only: :create

    def custom
      @user = User.find_or_create_from_auth_hash(auth_hash)
      self.current_user = @user
    end
  
    protected
  
    def auth_hash
      request.env['omniauth.auth']
    end
end
