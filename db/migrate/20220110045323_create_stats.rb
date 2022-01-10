class CreateStats < ActiveRecord::Migration[6.1]
  def change
    create_table :stats, id: :uuid do |t|
      t.string :stat_id
      t.string :stat_name
      t.string :stat_display_name

      t.timestamps
    end
  end
end
