# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  before(:each) do
    @user = FactoryBot.create(:user)
  end
  context 'Valid Attributes' do
    it '1. It should create a  User Model' do
      expect(@user).to be_valid
    end
    it '2. It should have unique emails and it can create 10 records' do
      9.times do
        FactoryBot.create(:user)
      end
      expect(User.count).to eq(10)
    end
    it '3. It should have a full_name' do
      expect(@user.full_name).to eq(User.first.full_name)
    end
    it '4. It should have an email' do
      expect(@user.email).to eq(User.first.email)
    end
  end
  context 'Invalid Attributes' do
    # it '1. It should not create a User Model without a full_name' do
    #   user = User.create(email: "test@gmail.com")
    #   expect(user).to_not be_valid
    # end
    it '1. It should not create a User Model without an email' do
      user = User.create(full_name: 'Test')
      expect(user).to_not be_valid
    end
    it '2. It should not create a User Model duplicate email' do
      User.create(full_name: 'Test', email: 'test@gmail.com')
      duplicated_user = User.create(full_name: 'Test2', email: 'test@gmail.com')
      expect(duplicated_user).to_not be_valid
    end
  end
end
