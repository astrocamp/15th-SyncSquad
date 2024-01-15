# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  attr_reader :user, :room

  def initialize(user, room)
    @user = user
    @room = room
  end

  def show_public_room
    true
  end

  def show_private_room?
    room.any? { |r| r.participants.exists?(user_id: user.id) }
  end

  def create_message?
    show_private_room?
  end
end
