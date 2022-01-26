class AddTeamLogoToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :team_logo, :string
  end
end
