class AddLeagueNameToLeagues < ActiveRecord::Migration[6.1]
  def change
    add_column :leagues, :league_name, :string
  end
end
