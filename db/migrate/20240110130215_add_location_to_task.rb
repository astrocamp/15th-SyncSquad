class AddLocationToTask < ActiveRecord::Migration[7.1]
  def change
    add_column :tasks, :location, :string
    add_column :tasks, :latitude, :float
    add_column :tasks, :longitude, :float
  end
end
