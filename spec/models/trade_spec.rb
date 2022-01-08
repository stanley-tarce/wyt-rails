require 'rails_helper'

RSpec.describe Trade, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
    @trade = FactoryBot.create(:trade, user: @user)
  end
  it "1. It should create a Trade Model with User Model" do
    expect(@trade).to be_valid
  end
  
  it "2. It should not create a Trade Model without a User Model" do
    trade = Trade.create()
    expect(trade).to_not be_valid
    expect(trade.errors.full_messages).to include("User must exist")
  end
  it "3. It should exist inside a User Model" do
    expect(@user.trades).to include(@trade)
  end
end
