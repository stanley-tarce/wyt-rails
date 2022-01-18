class AddPlayerKeyToPlayersToReceive < ActiveRecord::Migration[6.1]
  def change
    add_column :received_players, :player_key, :string
  end
end
