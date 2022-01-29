class CreateTokenHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :token_histories, id: :uuid do |t|
      t.string :access_token
      t.string :refresh_token
      t.string :expiry
      t.references :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
