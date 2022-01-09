class Comment < ApplicationRecord
    belongs_to :trade
    validates :name, presence: true
    validates :comment, presence: true
end
