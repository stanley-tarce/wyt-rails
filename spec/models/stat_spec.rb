# frozen_string_literal: true

require 'rails_helper'
stat_ex = [{ stat_id: 5, stat_name: 'Field Goal Percentage', stat_display_name: 'FG%' },
           { stat_id: 7, stat_name: 'Free Throws Made / Free Throws Attempted', stat_display_name: 'FTM/A' }, { stat_id: 9, stat_name: 'Points Scored', stat_display_name: 'PTS' }]

RSpec.describe Stat, type: :model do
  before do
    stat_ex.each do |stat|
      FactoryBot.create(:stat, stat_id: stat[:stat_id], stat_name: stat[:stat_name],
                               stat_display_name: stat[:stat_display_name])
    end
  end

  context 'Valid Attributes' do
    it '1. It should create a Stat Model' do
      expect(described_class.count) != 0
    end

    it '2. It should have a stat_id' do
      !expect(described_class.first.stat_id).nil?
    end

    it '3. It should have a stat_name' do
      !expect(described_class.first.stat_name).nil?
    end

    it '4. It should have a stat_display_name' do
      !expect(described_class.first.stat_display_name).nil?
    end
  end

  context 'Invalid Attributes' do
    it '1. It should not create a Stat Model without a stat_id' do
      stat = described_class.create(stat_name: 'Points Scored', stat_display_name: 'PTS')
      expect(stat).not_to be_valid
    end

    it '2. It should not create a State Model without a stat_name ' do
      stat = described_class.create(stat_id: 9, stat_display_name: 'PTS')
      expect(stat).not_to be_valid
    end

    it '3. It should not create a Stat Model without a stat_display_name' do
      stat = described_class.create(stat_id: 9, stat_name: 'Points Scored')
      expect(stat).not_to be_valid
    end

    it '4. It should not create a Stat Model if stat_id is not a number' do
      stat = described_class.create(stat_id: 'fasdfjasdlfkasj', stat_name: 'Points Scored', stat_display_name: 'PTS')
      expect(stat.errors.full_messages).to include('Stat must be a number')
    end
  end
end
