class AddTeamNameAndTeamKeyInLeagues < ActiveRecord::Migration[6.1]
  def change
    add_column :leagues, :team_name, :string
    add_column :leagues, :team_key, :string
  end
end
