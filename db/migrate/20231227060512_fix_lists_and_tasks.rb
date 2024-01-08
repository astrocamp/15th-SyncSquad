class FixListsAndTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :row_order, :integer
    add_column :lists, :row_order, :integer
    add_column :lists, :deleted_at, :datetime
    add_index :lists, :deleted_at
    add_index :tasks, :deleted_at
  end
end
