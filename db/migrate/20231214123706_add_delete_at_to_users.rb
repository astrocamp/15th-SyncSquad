class AddDeleteAtToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :delete_at, :timestamp
  end
end
