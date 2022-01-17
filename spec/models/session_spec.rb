require 'rails_helper'

RSpec.describe Session, type: :model do
  before(:each) do
    @session = FactoryBot.create(:session)
  end
  context "Valid Attributes" do
    it "1. It should create a session model" do
      expect(@session).to be_valid
    end
    it '2. It should have a token' do
      expect(@session.token.present?).to be true   
    end
    it '3. It should create multiple sessions' do
      13.times do
        FactoryBot.create(:session, user: @session.user) 
      end 
      expect(Session.count).to eq(14)
    end
    it '4. It should have a user' do
      expect(@session.user.present?).to be true
    end
    it '5. It should link to the same user if multiple sessions are created' do
      5.times do
        FactoryBot.create(:session, user: @session.user) 
      end
      Session.all.each do |session|
        expect(session.user).to eq(@session.user)
      end
    end
  end 
  

end
