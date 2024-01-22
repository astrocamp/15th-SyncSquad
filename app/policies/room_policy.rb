# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  attr_reader :user, :room

  def initialize(user, room)
    @user = user
    @room = room
  end

  def show_public_room
    user.company == room.company
  end

  def show_private_room?
    room.participants.exists?(user_id: user.id)
  end

  def create_message?
    room.exists? { |r| r.participants.exists?(user_id: user.id) }
  end
end
