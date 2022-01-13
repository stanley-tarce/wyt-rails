# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ActionController::Cookies
  include ActionController::RequestForgeryProtection
  skip_before_action :verify_authenticity_token
  # protect_from_forgery with: :null_session

  private

  def current_user
    cookie && Session.find_by(token: cookies.signed[:access_token2]) ?  Session.find_by(token: cookies.signed[:access_token2]).user : nil
  end

  def user_authenticated?
    cookie && Session.find_by(token: cookies.signed[:access_token2]) 
  end

  def require_token
    if request.headers['Authorization'].nil?
      render json: { error: 'Unauthorized', status: 401 }, status: 401
    else
      @access_token = request.headers['Authorization'].gsub('Bearer ', '')
    end
  end

  def token
    return current_user.access_token if current_user

    nil
  end

  def cookie
    return cookies.signed[:access_token2] if cookies.signed[:access_token2]

    nil
  end

  def check_token
    if token_expired?
      puts "Token has expired"
      cookies.signed[:access_token2] = {value: current_user.refresh_token_if_expired, expires: 72.hour, }
    else
      puts "Token hasn't expired! #{(current_user.expiry.to_i - Time.now.to_i)/60} minutes left"
    end
  end

  def token_expired?
    expiry = Time.at(current_user.expiry.to_i)
    return true if expiry < Time.now

    false
  end

  def authenticate_user!
    return render json: { error: 'No Access Token' }, status: 401 if cookies.signed[:access_token2].nil?
    return render json: { error: 'Invalid Token' }, status: 401 unless user_authenticated?
  end
  # will run before_action :check_token_expired? and before_action :authenticate_user!
end
