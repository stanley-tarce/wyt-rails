# frozen_string_literal: true

class Trade < ApplicationRecord
  has_many :received_players, dependent: :destroy
  has_many :sent_players, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :team_name, presence: true
  validates :team_key, presence: true
  validates :team_logo, presence: true
  belongs_to :league
end
