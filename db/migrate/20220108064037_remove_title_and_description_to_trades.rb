class RemoveTitleAndDescriptionToTrades < ActiveRecord::Migration[6.1]
  def change
    remove_column :trades, :title
    remove_column :trades, :description
  end
end
