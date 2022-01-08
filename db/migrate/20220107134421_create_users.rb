class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, null: false
      t.string :full_name

      t.timestamps
    end
  end
end
