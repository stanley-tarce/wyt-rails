class DeleteTokenHistories < ActiveRecord::Migration[6.1]
  def change
    drop_table :token_histories
  end
end
