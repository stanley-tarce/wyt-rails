class RemoveTeamNameInLeagues < ActiveRecord::Migration[6.1]
  def change
    remove_column :leagues, :league_name
  end
end
