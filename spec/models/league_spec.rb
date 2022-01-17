require 'rails_helper'

RSpec.describe League, type: :model do
  before(:each) do
    @league = FactoryBot.create(:league)
  end
  context "Valid Attributes" do
    it "1. It should create a League Model" do
      expect(@league).to be_valid
    end
    it "2. It should have a league_id" do
      expect(@league.league_id).to eq(League.first.league_id)
    end
    it "3. It should exit inside a user" do
      expect(@league.user).to eq(League.first.user)
    end
  end
  context "Invalid Attributes" do
    it "1. It should not create a League Model without a league_id" do
      league = League.create( user: @user)
      expect(league).to_not be_valid
    end
    it "2. It should not create a League Model without a user" do
      league = League.create( league_id: (rand()*10000).ceil)
      expect(league).to_not be_valid
    end
  end
end
