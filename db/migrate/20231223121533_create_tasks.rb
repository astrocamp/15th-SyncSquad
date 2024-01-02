class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.belongs_to :list, null: false, foreign_key: true
      #t.belongs_to :lists, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.integer :priority
      t.timestamp :started_at
      t.timestamp :completed_at
      t.timestamp :estimated_completed_at
      t.timestamp :deleted_at
      t.timestamp :ended_at
      t.boolean :all_day_event
      t.string :source

      t.timestamps
    end
  end
end
