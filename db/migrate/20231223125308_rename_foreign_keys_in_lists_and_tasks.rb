class RenameForeignKeysInListsAndTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :lists, :projects_id, :project_id
    rename_column :tasks, :lists_id, :list_id
  end
end
