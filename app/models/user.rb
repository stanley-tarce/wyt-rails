# frozen_string_literal: true

class User < ApplicationRecord
    has_many :leagues
    validates :email, presence: true, uniqueness: true
    has_many :sessions
    def refresh_token_if_expired
            response = Yahoo::Refresh.call({'refresh_token': self.refresh_token, 'client_id': ENV['YAHOO_CLIENT_ID_STAN_V2'], 'client_secret': ENV['YAHOO_CLIENT_SECRET_STAN_V2'], 'grant_type': 'refresh_token' })
            self.access_token = response[:data]['access_token']
            self.expiry = Time.now.to_i + response[:data]['expires_in'].to_i
            self.save
            Session.create(user: self, token: self.access_token)
            return response[:data]['access_token']
    end
    
  private

    def token_expired?
      expiry = Time.at(self.expiry.to_i)
      return true if expiry < Time.now

      return false
    end
end
