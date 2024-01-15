class AddRoomTypeToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :room_type, :integer, default: 0
    # 更新資料庫記錄
    Room.where("name LIKE ?", "private_%_%").where(room_type: 0).update_all(room_type: 1)
  end

  def down
    remove_column :rooms, :room_type
  end
end
