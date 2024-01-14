class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.integer :user_id
      t.integer :company_id
      t.integer :price 
      t.string :serial_num

      t.timestamps
    end
  end
end
