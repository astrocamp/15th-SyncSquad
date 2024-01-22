# frozen_string_literal: true

class Room < ApplicationRecord
  # validation: room's name could not recurring and create public room
  validates :name, presence: true, uniqueness: true
  after_create_commit { broadcast_if_public }
  has_many :messages
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  belongs_to :company

  enum room_type: { public_room: 0, single_room: 1, private_room: 2 }

  def broadcast_if_public
    broadcast_append_to 'rooms' if public_room?
  end

  def public_room?
    self.room_type == 'public_room'
  end

  def broadcast_if_private_group
    return unless private_room?

    participants.each do |participant|
      broadcast_append_to "private_rooms_for_user_#{participant.user_id}", target: 'private_rooms'
    end
  end

  def self.create_private_room(current_user, users, room_name)
    return unless users.map(&:company_id).uniq.length == 1

    single_room = Room.create(name: room_name, room_type: 'single_room', company: current_user.company)

    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end

    single_room if single_room.save

    users.each do |user|
      Participant.create(user_id: user.id, room_id: single_room.id)
    end

    return unless single_room.save

    single_room
  end

  def participant?(room, user)
    room.participants.exists?(user:)
  end
end
