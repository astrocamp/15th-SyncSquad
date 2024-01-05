class AddColumnsToTasksForCalendar < ActiveRecord::Migration[7.1]
  def change
    remove_column :tasks, :start_at, :datetime
    add_column :tasks, :start_date, :date
    add_column :tasks, :start_datetime, :datetime
    add_column :tasks, :start_timezone, :string
    add_column :tasks, :end_date, :date
    add_column :tasks, :end_datetime, :datetime
    add_column :tasks, :end_timezone, :string
    add_column :tasks, :all_day_event, :boolean, default: false
    add_column :tasks, :private, :boolean, default: true
    add_column :tasks, :location, :string
    add_column :tasks, :source, :string
  end
end
