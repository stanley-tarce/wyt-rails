# frozen_string_literal: true

class Stat < ApplicationRecord
  validates :stat_id, presence: true, uniqueness: true, format: { with: /\A\d+\z/, message: 'must be a number' }
  validates :stat_name, presence: true
  validates :stat_display_name, presence: true
end
