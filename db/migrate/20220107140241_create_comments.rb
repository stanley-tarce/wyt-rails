class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments,id: :uuid do |t|
      t.string :name
      t.text :comment
      t.references :trade, type: :uuid, null:false, foreign_key: true

      t.timestamps
    end
  end
end
