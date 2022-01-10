class League < ApplicationRecord
    belongs_to :user
    has_many :trades
    validates :league_id, presence: true, uniqueness: true
    validates :league_name, presence: true
end