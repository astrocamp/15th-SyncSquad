class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :lists, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :priority
      t.timestamp :start_at
      t.timestamp :complete_at
      t.integer :estimated_complete_at
      t.timestamp :deleted_at

      t.timestamps
    end
  end
end
