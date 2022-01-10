class Trade < ApplicationRecord
    has_many :received_players
    has_many :sent_players
    has_many :comments
    belongs_to :league
end
