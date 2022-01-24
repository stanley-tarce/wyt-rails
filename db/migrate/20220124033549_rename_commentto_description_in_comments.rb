class RenameCommenttoDescriptionInComments < ActiveRecord::Migration[6.1]
  def change
    rename_column :comments, :comment, :description
  end
end
