# frozen_string_literal: true

class UsersController < ApplicationController
  # before_action :check_token, only: [:index]

  # prepend_before_action :authenticate_user!, only: [:index]

  def index
    # puts current_user.inspect
    # puts cookies.signed[:access_token2]
    # cookies.signed[:access_token2] = {value: User.first.access_token, expires: 72.hour }
    # cookies.delete(:access_token)
    cookies.signed[:access_token2] = {value: User.first.access_token, expires: 72.hour, domain: 'stock-app-react.vercel.app' }
    render json: { message: "User successfully logged in"}, status: :ok
  end
  def cookie
    render json: cookies[:access_token2]
  end

  private


end
