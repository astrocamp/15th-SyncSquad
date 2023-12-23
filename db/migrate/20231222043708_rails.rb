class Rails < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  
    add_column :events, :deleted_at, :datetime
    add_index :events, :deleted_at
  end
end
