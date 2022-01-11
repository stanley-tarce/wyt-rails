# frozen_string_literal: true

class ReceivedPlayer < ApplicationRecord
  validates :player_name, presence: true
  belongs_to :trade
end
