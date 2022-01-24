# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :trade
  validates :name, presence: true
  validates :description, presence: true
end
