# frozen_string_literal: true

class Room < ApplicationRecord
  # validation: room's name could not recurring and create public room
  validates :name, presence: true, uniqueness: true
  scope :public_rooms, -> { where(is_private: false) }
  after_create_commit { broadcast_append_to 'rooms' }
  has_many :messages
end