class Comment < ApplicationRecord
    belongs_to :trade
    validates :name, presence: true
    validates :comment, prescence: true
end
