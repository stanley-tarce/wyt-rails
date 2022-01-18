# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReceivedPlayer, type: :model do
  before(:each) do
    @receivedPlayer = FactoryBot.create(:received_player)
  end
  context 'Valid Attributes' do
    it '1. It should be valid with valid attributes' do
      expect(@receivedPlayer).to be_valid
    end
    it '2. It should have a player_name attribute' do
      expect(@receivedPlayer.player_name).to eq(ReceivedPlayer.first.player_name)
    end
    it '3. It should have a player_key attribute' do
      expect(@receivedPlayer.player_key).to eq(ReceivedPlayer.first.player_key)
    end
    it '4. It should exist inside a trade model' do
      expect(@receivedPlayer.trade).to eq(Trade.first)
    end
    it '5. It should have a user' do
      expect(@receivedPlayer.trade.league.user).to eq(User.first) 
    end
  end
  context 'Invalid Attributes' do
    it '1. It should not be able to create a model without a player name' do
      received_player = ReceivedPlayer.create(trade: Trade.first, player_key: "12345")
      expect(received_player).to_not be_valid
    end
    it '2. It should not be able to create a model without a player key' do
      received_player = ReceivedPlayer.create(trade: Trade.first, player_name: "Test")
      expect(received_player).to_not be_valid
    end
    it '2. It should not be able to create a model without existing inside a trade model' do
      received_player = ReceivedPlayer.create(player_name: Faker::Name.name)
      expect(received_player).to_not be_valid
    end
  end
end
