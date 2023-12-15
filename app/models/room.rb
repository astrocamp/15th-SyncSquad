class Room < ApplicationRecord
	#validation: room's name could not recurring and create public room
	validates_uniqueness_of :name
  scope :public_rooms, -> { where(is_private: false) }
end
