# frozen_string_literal: true

class SentPlayer < ApplicationRecord
  validates :player_key, presence: true
  validates :player_name, presence: true
  belongs_to :trade
end
