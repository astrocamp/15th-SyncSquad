class RenameDeleteAtToDeletedAt < ActiveRecord::Migration[7.1]
  def change
    rename_column :projects, :delete_at, :deleted_at
  end
end
