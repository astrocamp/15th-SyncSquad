class AddRowOrderListsAndTasks < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :row_order, :integer
    add_column :lists, :row_order, :integer
  end
end
