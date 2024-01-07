# frozen_string_literal: true

class Room < ApplicationRecord
  # validation: room's name could not recurring and create public room
  validates :name, presence: true, uniqueness: true
  scope :public_rooms, -> { where(is_private: false) }
  after_create_commit { broadcast_if_public }
  has_many :messages
  has_many :participants, dependent: :destroy

  enum room_type: { public_room: 0, single_room: 1, private_room: 2 }

  def broadcast_if_public
    broadcast_append_to 'rooms' unless is_private
  end

  def broadcast_if_private_group
    if private_room?
      participants.each do |participant|
        broadcast_append_to "private_rooms_for_user_#{participant.user_id}", target:"private_rooms"
      end
    end
  end

  def self.create_private_room(users, room_name)
    single_room = Room.create(name: room_name, is_private: true, room_type: 1)
    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end
    single_room
  end

  def participant?(room, user)
    room.participants.where(user:).exists?
    Participant.where(user_id: user.id, room_id: room.id).exists?
  end
end
