class DropTaskResposiblePeopleTableAndAddColumnToTask < ActiveRecord::Migration[7.1]
  def change
    drop_table :task_responsible_people

    add_belongs_to :tasks, :user
  end
end
