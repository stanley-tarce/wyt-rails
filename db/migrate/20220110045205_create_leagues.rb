class CreateLeagues < ActiveRecord::Migration[6.1]
  def change
    create_table :leagues, id: :uuid do |t|
      t.string :league_id
      t.string :league_name
      t.timestamps
    end
  end
end
