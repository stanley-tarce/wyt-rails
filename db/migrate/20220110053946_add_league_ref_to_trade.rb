class AddLeagueRefToTrade < ActiveRecord::Migration[6.1]
  def change
    add_reference :trades, :league, null: false, foreign_key: true, type: :uuid
    remove_reference :trades, :user, type: :uuid, null:false, foreign_key: true
  end
end
