# frozen_string_literal: true
class RoomVisit < ApplicationRecord
  belongs_to :user
  belongs_to :room
end