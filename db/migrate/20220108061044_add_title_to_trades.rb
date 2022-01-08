class AddTitleToTrades < ActiveRecord::Migration[6.1]
  def change
    add_column :trades, :title, :string
    add_column :trades, :description, :text
  end
end
