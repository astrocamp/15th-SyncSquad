class RemoveIsPrivateFromRooms < ActiveRecord::Migration[7.1]
    def up
      remove_column :rooms, :is_private
    end
  
    def down
      add_column :rooms, :is_private, :boolean, default: false
    end
end
