class AddTeamToTradeWithInTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :team_name, :string
    add_column :trades, :team_id, :string
  end
end
