# frozen_string_literal: true

class ApplicationController < ActionController::API
  private

  def current_user(token)
    token && User.find_by_access_token(token) ? User.find_by_access_token(token) : nil
  end 

  def user_authenticated?
    token && User.find_by_access_token(token)
  end

  def require_token
    if request.headers['Authorization'].nil?
      render json: { error: 'Unauthorized', status: 401 }, status: 401
    else
      @access_token = request.headers['Authorization'].gsub('Bearer ', '')
    end
  end

  def token
     return request.headers['Authorization'].gsub('Bearer ', '') if request.headers['Authorization']
     nil
  end

  def set_response_headers
    response.set_header('access_token', current_user.access_token)
  end
  # def use_current_token
  #   if check_token_expired_v2?
  #     new_access_token = current_user.refresh_token_if_expired[:access_token]
  #     return new_access_token
  #   else  
  #     return current_user.access_token
  #   end
  # end
  def check_token_expired
     current_user.refresh_token_if_expired   
  end
   def check_token_expired_v2?
    Time.at(current_user.expiry.to_i) < Time.now
  end

  def authenticate_user!
    return render json: { error: 'No Access Token', status: 401 }, status: 401 if request.headers['Authorization'].nil?
    return render json: { error: "Invalid Token"}, status: 401 unless user_authenticated?
  end
  # will run before_action :check_token_expired? and before_action :authenticate_user!
end
