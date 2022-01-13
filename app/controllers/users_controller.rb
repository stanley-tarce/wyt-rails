# frozen_string_literal: true

class UsersController < ApplicationController
  # before_action :check_token, only: [:index]

  # prepend_before_action :authenticate_user!, only: [:index]

  def index
    # puts current_user.inspect
    # puts cookies.signed[:access_token2]
    # cookies.signed[:access_token2] = {value: User.first.access_token, expires: 72.hour }
    # cookies.delete(:access_token)
    # cookie_value = request.headers['Cookie'].split('=')[1].split('--').first
    # verify_and_decrypt(cookie_value)
    # cookie_value = CGI::unescape(cookie_value)
    # cookie_payload = JSON.parse Base64.decode64(cookie_value)
    # puts Base64.decode64 cookie_payload['_rails']['message']
    # if cookies.signed[:access_token]
    #   puts "Cookie Found"
    #   puts cookies.signed[:access_token]
    # end
    cookies[:access_token2] = {value: User.first.access_token, expires: 72.hour }
    render json: { message: "User successfully logged in"}, status: :ok
  end
  def cookie
    render json: cookies[:access_token2]
  end

  private


end
