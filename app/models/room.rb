# frozen_string_literal: true

class Room < ApplicationRecord
  # validation: room's name could not recurring and create public room
  # after_create_commit { broadcast_if_public }
  has_many :messages, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  belongs_to :company

  has_many :room_visits, dependent: :destroy
  has_many :users, through: :room_visits

  enum room_type: { public_room: 0, single_room: 1, private_room: 2 }

  def broadcast_if_public(current_user)
    broadcast_append_to "rooms_company_#{self.company_id}" if public_room?(current_user)
  end

  def public_room?(current_user)
    self.room_type == 'public_room' && self.company_id == current_user.company_id
  end

  def private_room?
    self.room_type == 'private_room'
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
    single_room
  end

  def participant?(room, user)
    room.participants.where(user:).exists?
    Participant.where(user_id: user.id, room_id: room.id).exists?
  end

  def unread_messages_count(user)

    return 0 unless user.present?

    last_visit = ::RoomVisit.find_by(user_id: user.id, room_id: self.id)
    return 0 unless last_visit

    messages.where('created_at > ?', last_visit.last_visited_at).where.not(user_id: user.id).count
  end
end
