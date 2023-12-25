class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :email
      t.string :password

      t.timestamps
    end

    add_index :companies, :email, unique: true
    add_index :companies, :name, unique: true
  end
end
