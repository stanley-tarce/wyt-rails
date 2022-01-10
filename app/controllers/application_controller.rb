class ApplicationController < ActionController::API
    private
    def current_user
        token && User.find_by_access_token(token) ? User.find_by_access_token(token)  : nil
    end

    def user_authenticated?
        true if current_user
        false
    end

    def require_token
        if request.headers['Authorization'] == nil 
            render json: { error: 'Unauthorized', status: 401 }, status: 401
        else 
            @access_token = request.headers['Authorization'].gsub("Bearer ","")
        end
    end

    def token
        request.headers['Authorization'].gsub("Bearer ","")
    end

    def check_token_expired?
        current_user.refresh_token_if_expired
    end
end
