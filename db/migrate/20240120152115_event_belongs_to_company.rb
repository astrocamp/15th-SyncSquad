class EventBelongsToCompany < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :user_id
    remove_column :events, :private
    remove_column :events, :start_date
    remove_column :events, :start_time
    remove_column :events, :end_date
    remove_column :events, :end_time
    add_column :events, :company_id, :integer
    add_column :events, :started_at, :datetime, :null => false
    add_column :events, :ended_at, :datetime, :null => false
  end
end
