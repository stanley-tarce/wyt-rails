class AddPlayerKeyToPlayersToSend < ActiveRecord::Migration[6.1]
  def change
    add_column :sent_players, :player_key, :string

  end
end
