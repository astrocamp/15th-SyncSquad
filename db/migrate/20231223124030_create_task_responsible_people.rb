class CreateTaskResponsiblePeople < ActiveRecord::Migration[7.1]
  def change
    create_table :task_responsible_people do |t|
      t.references :tasks, null: false, foreign_key: true
      t.references :users, null: false, foreign_key: true

      t.timestamps
    end
  end
end
