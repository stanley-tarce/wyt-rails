class AddRefreshTokenAndExpiryToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :refresh_token, :string
    add_column :users, :expiry, :string
  end
end
