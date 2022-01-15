# frozen_string_literal: true

class UsersController < ApplicationController


  def index

    cookies.signed[:access_token2] = {value: User.first.access_token, expires: 72.hour, domain: 'herokuapp.com' }
    render json: { message: "User successfully logged in"}, status: :ok
  end
  def cookie
    render json: cookies[:access_token2]  
  end

  private


end
