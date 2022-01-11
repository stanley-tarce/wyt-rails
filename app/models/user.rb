# frozen_string_literal: true

class User < ApplicationRecord
  has_many :leagues
  validates :email, presence: true, uniqueness: true
  def refresh_token_if_expired
    if token_expired?
      response = Yahoo::Refresh.refresh({ 'refresh_token': refresh_token,
                                          'client_id': ENV['WYT_RAILS_CONSUMER_KEY'], 'client_secret': ENV['WYT_RAILS_CONSUMER_SECRET'], 'grant_type': 'refresh_token' })
      self.access_token = response[:data]['access_token']
      self.expiry = Time.now.to_i + response[:data]['expires_in'].to_i
      save
      puts 'Token refreshed'
    else
      puts "Token not expired! Time left: #{(expiry.to_i - Time.now.to_i) / 60} minutes"
    end
  end

  private

  def token_expired?
    expiry = Time.at(self.expiry.to_i)
    return true if expiry < Time.now

    false
  end
end
