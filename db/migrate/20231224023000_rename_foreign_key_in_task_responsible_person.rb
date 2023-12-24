class RenameForeignKeyInTaskResponsiblePerson < ActiveRecord::Migration[7.1]
  def change
    rename_column :task_responsible_people, :tasks_id, :task_id
    rename_column :task_responsible_people, :users_id, :user_id
  end
end
