class Trade < ApplicationRecord
    has_many :Player_to_receive
    has_many :Player_to_send
    has_many :Comments
    belongs_to :User
end
