class FixListsAndTasks < ActiveRecord::Migration[7.1]
  def change
    rename_column :lists, :projects_id, :project_id
    rename_column :tasks, :lists_id, :list_id
    rename_column :task_responsible_people, :tasks_id, :task_id
    rename_column :task_responsible_people, :users_id, :user_id
    add_column :tasks, :row_order, :integer
    add_column :lists, :row_order, :integer
    add_column :lists, :deleted_at, :datetime
    add_index :lists, :deleted_at
    add_index :tasks, :deleted_at
    remove_column :tasks, :estimated_complete_at
    add_column :tasks, :estimated_complete_at
  end
end
