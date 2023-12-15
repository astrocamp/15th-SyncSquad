class CreateEvents < ActiveRecord::Migration[7.1]
  def change
    create_table :events do |t|
      t.string :subject, null: false
      t.date :start_date, null: false
      t.time :start_time
      t.date :end_date, null: false
      t.time :end_time
      t.boolean :all_day_event, default: false
      t.text :description
      t.text :location
      t.boolean :private, default: false
      t.timestamps
    end
  end
end
