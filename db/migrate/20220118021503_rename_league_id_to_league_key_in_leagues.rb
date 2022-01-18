class RenameLeagueIdToLeagueKeyInLeagues < ActiveRecord::Migration[6.1]
  def change
    rename_column :leagues, :league_id, :league_key
  end
end
