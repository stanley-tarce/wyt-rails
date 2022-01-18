# frozen_string_literal: true

class League < ApplicationRecord
  belongs_to :user
  has_many :trades, dependent: :destroy
  validates :league_key, presence: true, uniqueness: true
  validates :team_name, presence: true
  validates :team_key, presence: true
end
