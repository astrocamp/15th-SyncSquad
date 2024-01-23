class RemoveCompletedAtToTask < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :completed_at, :datetime
    remove_column :tasks, :estimated_completed_at, :datetime
  end
end
