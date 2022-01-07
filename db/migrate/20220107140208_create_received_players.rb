class CreateReceivedPlayers < ActiveRecord::Migration[6.1]
  def change
    create_table :received_players do |t|
      t.string :player_name
      t.references :trade, type: :uuid, null:false, foreign_key: true

      t.timestamps
    end
  end
end
