class CreateTrades < ActiveRecord::Migration[6.1]
  def change
    create_table :trades, id: :uuid do |t|
      t.references :user, type: :uuid, null:false, foreign_key: true

      t.timestamps
    end
  end
end
