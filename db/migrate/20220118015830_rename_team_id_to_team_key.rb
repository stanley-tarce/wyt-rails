class RenameTeamIdToTeamKey < ActiveRecord::Migration[6.1]
  def change
    rename_column :trades, :team_id, :team_key
  end
end
