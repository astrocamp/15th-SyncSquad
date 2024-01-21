class CreateRoomVisits < ActiveRecord::Migration[7.1]
  def change
    create_table :room_visits do |t|
      t.references :user, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true
      t.datetime :last_visited_at

      t.timestamps
    end
  end
end
