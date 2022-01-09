# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trade, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @trade = FactoryBot.create(:trade, user: @user)
  end
  context 'Valid Attributes' do
    it '1. It should create a Trade Model' do
      expect(@trade).to be_valid
    end
    it '2. It should exist inside a User Model' do
      expect(@user.trades).to include(@trade)
    end
  end

  context  'Invalid Attributes' do
    it '1. It should not create a Trade Model without a User Model' do
      trade = Trade.create
      expect(trade).to_not be_valid
     
    end
    it '2. It should have an error message of "User must exist"' do
      trade = Trade.create
      expect(trade.errors.full_messages).to include("User must exist")
    end

  end
end
