# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Session, type: :model do
  before do
    @session = FactoryBot.create(:session)
  end

  context 'Valid Attributes' do
    it '1. It should create a session model' do
      expect(@session).to be_valid
    end

    it '2. It should have a token' do
      expect(@session.token.present?).to be true
    end

    it '3. It should create multiple sessions' do
      FactoryBot.create_list(:session, 13, user: @session.user)
      expect(described_class.count).to eq(14)
    end

    it '4. It should have a user' do
      expect(@session.user.present?).to be true
    end

    it '5. It should link to the same user if multiple sessions are created' do
      FactoryBot.create_list(:session, 5, user: @session.user)
      described_class.all.each do |session|
        expect(session.user).to eq(@session.user)
      end
    end
  end
end
