class CreateProjects < ActiveRecord::Migration[7.1]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description
      t.integer :owner_id, null: false
      t.timestamp :delete_at

      t.timestamps
    end

    
    add_index :projects, :delete_at
  end
end
