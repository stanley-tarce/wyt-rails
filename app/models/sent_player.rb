class SentPlayer < ApplicationRecord
    validates :player_name, presence: true
    belongs_to :trade
end
