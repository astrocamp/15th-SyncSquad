class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :email
      t.string :password
      t.integer :gui

      t.timestamps
    end
  end
end
