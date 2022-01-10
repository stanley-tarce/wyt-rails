class User < ApplicationRecord
    has_many :leagues
    validates :email, presence: true, uniqueness: true
end
