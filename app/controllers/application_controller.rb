# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::RequestForgeryProtection

  # Four Main Methods

  private

  def current_user
    token && Session.find_by(token: token) ?  Session.find_by(token: token).user : nil
  end

  def user_authenticated?
    current_user.present? 
  end

  def require_token # Can call or not call this method
    if request.headers['Authorization'].nil?
      render json: { error: 'Unauthorized', status: 401 }, status: 401
    else
      @access_token = request.headers['Authorization'].gsub('Bearer ', '')
    end
  end

  def updated_token
    return current_user.access_token if current_user

    nil
  end

  def token
    return request.headers['Authorization'].gsub('Bearer ', '') if request.headers['Authorization']
    nil
  end

  def check_token
    if token_expired?
      return current_user.refresh_token_if_expired
    end
  end

  def token_expired?
    expiry = Time.at(current_user.expiry.to_i)
    return true if expiry < Time.now

    false
  end
  def set_response_header
    response.headers['Authorization'] = current_user.access_token
  end

  def authenticate_user!
    return render json: { error: 'No Access Token' }, status: 401 if token.nil?
    return render json: { error: 'Invalid Token' }, status: 401 unless user_authenticated?
  end
  def user_params
    params.permit(:league_key, :team_key, :player_keys)
  end
  # will run before_action :check_token_expired? and before_action :authenticate_user!
end
