# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  before(:each) do
    @comment = FactoryBot.create(:comment)
  end
  context 'Valid Attributes' do
    it '1. It should create a Comment Model' do
      expect(@comment).to be_valid
    end
    it '2. It should have a name' do
      expect(@comment.name).to eq(Comment.first.name)
    end
    it '3. It should have a comment' do
      expect(@comment.comment).to eq(Comment.first.comment)
    end
    it '4. It should exit inside a trade' do
      expect(@comment.trade).to eq(Comment.first.trade)
    end
    it '4. It Should have a user' do
      leagueId = @comment.trade.league_id
      expect(User.find(League.find(leagueId).user_id)).to eq(Comment.first.trade.league.user)
    end
  end
  context 'Invalid Attributes' do
    it '1. It should not be able to create without a name' do
      trade = FactoryBot.create(:trade)
      comment = Comment.create(comment: 'This is a comment', trade: trade)
      expect(comment).to_not be_valid
    end
    it '2. It should not be able to create without a comment' do
      trade = FactoryBot.create(:trade)
      comment = Comment.create(name: 'This is a name', trade: trade)
      expect(comment).to_not be_valid
    end
    it '3. It should not be able to create without a trade' do
      comment = Comment.create(name: 'This is a name', comment: 'This is a comment')
      expect(comment).to_not be_valid
    end
  end
end
