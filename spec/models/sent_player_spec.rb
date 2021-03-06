# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SentPlayer, type: :model do
  before do
    @sentPlayer = FactoryBot.create(:sent_player)
  end

  context 'Valid Attributes' do
    it '1. It should be valid with valid attributes' do
      expect(@sentPlayer).to be_valid
    end

    it '2. It should have a player_name attribute' do
      expect(@sentPlayer.player_name).to eq(described_class.first.player_name)
    end

    it '3. It should have a player_key attribute' do
      expect(@sentPlayer.player_key).to eq(described_class.first.player_key)
    end

    it '4. It should exist inside a trade model' do
      expect(@sentPlayer.trade).to eq(Trade.first)
    end

    it '5. It should have a user' do
      expect(@sentPlayer.trade.league.user).to eq(User.first)
    end
  end

  context 'Invalid Attributes' do
    it '1. It should not be able to create a model without a player_key' do
      sent_player = described_class.create(trade: Trade.first, player_name: 'Test')
      expect(sent_player).not_to be_valid
    end

    it '2. It should not be able to create a model without a player_name' do
      sent_player = described_class.create(trade: Trade.first, player_key: '12345')
      expect(sent_player).not_to be_valid
    end

    it '3. It should not be able to create a model without existing inside a trade model' do
      sent_player = described_class.create(player_name: Faker::Name.name)
      expect(sent_player).not_to be_valid
    end
  end
end
