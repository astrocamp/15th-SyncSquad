class CreateCalendars < ActiveRecord::Migration[7.1]
  def change
    create_table :calendars do |t|
      t.string :title, null: false
      t.text :description
      t.string :color, null: false
      t.string :timezone, null: false
      t.timestamps
    end
  end
end


