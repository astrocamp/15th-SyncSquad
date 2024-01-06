class CreateImportrecords < ActiveRecord::Migration[7.1]
  def change
    create_table :importrecords do |t|
      t.string :status
      t.string :file
      t.integer :total_count
      t.integer :success_count
      t.text :error_messages
      t.integer :company_id
      t.integer :user_id
      t.timestamps
    end
  end
end
