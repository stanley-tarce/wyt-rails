# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SentPlayer, type: :model do
  before(:each) do
    @sentPlayer = FactoryBot.create(:sent_player)
  end
  context 'Valid Attributes' do
    it '1. It should be valid with valid attributes' do
      expect(@sentPlayer).to be_valid
    end
    it '2. It should have a player_name attribute' do
      expect(@sentPlayer.player_name).to eq(SentPlayer.first.player_name)
    end
    it '3. It should exist inside a trade model' do
      expect(@sentPlayer.trade).to eq(Trade.first)
    end
  end
  context 'Invalid Attributes' do
    it '1. It should not be able to create a model without a player' do
      sent_player = SentPlayer.create(trade: Trade.first)
      expect(sent_player).to_not be_valid
    end
    it '2. It should not be able to create a model without existing inside a trade model' do
      sent_player = SentPlayer.create(player_name: Faker::Name.name)
      expect(sent_player).to_not be_valid
    end
  end
end
