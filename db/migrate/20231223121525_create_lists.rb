class CreateLists < ActiveRecord::Migration[7.1]
  def change
    create_table :lists do |t|
      t.string :title
      t.belongs_to :projects, null: false, foreign_key: true
      t.string :color

      t.timestamps
    end
  end
end