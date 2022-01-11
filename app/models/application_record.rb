# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  # in order to make ordering work (.first, .last) with UUID, we sort by created_at instead of ID
  self.implicit_order_column = :created_at
end
