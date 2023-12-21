class AddColumnToNewCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :name, :string
    add_column :companies, :hr_name, :string
    add_column :companies, :hr_email, :string
    add_column :companies, :hr_password, :string
    add_index :companies, :hr_email, unique: true
    
  end
end
