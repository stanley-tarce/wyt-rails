# frozen_string_literal: true

require 'rails_helper'

RSpec.describe League, type: :model do
  before do
    @league = FactoryBot.create(:league)
  end

  context 'Valid Attributes' do
    it '1. It should create a League Model' do
      expect(@league).to be_valid
    end

    it '2. It should have a league_key' do
      expect(@league.league_key).to eq(described_class.first.league_key)
    end

    it '3. It should have a team_name' do
      expect(@league.team_name).to eq(described_class.first.team_name)
    end

    it '4. It should have a team_key' do
      expect(@league.team_key).to eq(described_class.first.team_key)
    end

    it '5. It should exit inside a user' do
      expect(@league.user).to eq(described_class.first.user)
    end
  end

  context 'Invalid Attributes' do
    it '1. It should not create a League Model without a league_key' do
      league = described_class.create(user: @user, team_key: '12345', team_name: 'Boston Celtics')
      expect(league).not_to be_valid
    end

    it '2. It should not create a League Model without a team_name' do
      league = described_class.create(user: @user, league_key: '12345', team_key: '12345')
      expect(league).not_to be_valid
    end

    it '3. It should not create a League Model without a team_key' do
      league = described_class.create(user: @user, league_key: '12345', team_name: 'Boston Celtics')
      expect(league).not_to be_valid
    end

    it '4. It should not create a League Model without a user' do
      league = described_class.create(league_key: (rand * 10_000).ceil, team_key: '12345', team_name: 'Boston Celtics')
      expect(league).not_to be_valid
    end
  end
end
