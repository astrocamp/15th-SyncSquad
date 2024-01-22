class AddPayToCompany < ActiveRecord::Migration[7.1]
  def change
    add_column :companies, :paid, :boolean
  end
end
