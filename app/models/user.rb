# frozen_string_literal: true

class User < ApplicationRecord
  has_many :leagues, dependent: :destroy
  validates :email, presence: true, uniqueness: true
  has_many :sessions

  def refresh_token_from_trade_params
    Session.create(user: self, token: access_token)
    return refresh
  end

  def refresh_token_if_expired
    refresh
    Session.create(user: self, token: access_token)
  end

  private

  def refresh
    response = Yahoo::Refresh.call({ 'refresh_token': refresh_token, 'client_id': ENV['WYT_RAILS_CONSUMER_KEY'],
                                     'client_secret': ENV['WYT_RAILS_CONSUMER_SECRET'], 'grant_type': 'refresh_token' })
    self.access_token = response[:data]['access_token']
    self.expiry = Time.now.to_i + response[:data]['expires_in'].to_i
    save
    return response[:data]['access_token']
  end
end
