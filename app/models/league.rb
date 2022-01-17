# frozen_string_literal: true

class League < ApplicationRecord
  belongs_to :user
  has_many :trades
  validates :league_id, presence: true, uniqueness: true
end
