class User < ApplicationRecord
    has_many :trades
    validates :email, presence: true, uniqueness: true
    validates :full_name, presence: true
end
