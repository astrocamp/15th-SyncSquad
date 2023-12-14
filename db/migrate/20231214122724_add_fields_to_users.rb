class AddFieldsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :name, :string
    add_column :users, :gender, :integer
    add_column :users, :birthday, :timestamp
    add_column :users, :phone, :string
    add_column :users, :username, :string
    add_column :users, :last_login_at, :timestamp
    add_column :users, :role, :string
    add_column :users, :lang, :string
    add_column :users, :time_zone, :string
  end
end
