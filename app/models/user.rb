# frozen_string_literal: true

class User < ApplicationRecord
    has_many :leagues
    validates :email, presence: true, uniqueness: true
    def refresh_token_if_expired
        if token_expired?
            response = Yahoo::Refresh.refresh({'refresh_token': self.refresh_token, 'client_id': ENV['YAHOO_CLIENT_ID_STAN_V2'], 'client_secret': ENV['YAHOO_CLIENT_SECRET_STAN_V2'], 'grant_type': 'refresh_token' })
            self.access_token = response[:data]['access_token']
            self.expiry = Time.now.to_i + response[:data]['expires_in'].to_i
            self.save
            puts 'Token refreshed'
            return response[:data]['access_token']
        else 
            puts "Token not expired. #{(self.expiry.to_i - Time.now.to_i  ).to_f/60} minutes left"
        end
    end
    
  private

    def token_expired?
      expiry = Time.at(self.expiry.to_i)
      return true if expiry < Time.now

      false
    end
end
