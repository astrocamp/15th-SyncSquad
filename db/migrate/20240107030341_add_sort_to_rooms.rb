class AddSortToRooms < ActiveRecord::Migration[7.1]
  def change
    add_column :rooms, :sort, :integer, default: 0
  end
end
