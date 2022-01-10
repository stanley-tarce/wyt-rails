class ApplicationController < ActionController::API
    private
    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id] 
    end
    def authenticate_user
        true if User.find(session[:user_id])
        false
    end
end
