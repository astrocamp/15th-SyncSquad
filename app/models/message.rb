# frozen_string_literal: true

class Message < ApplicationRecord
  validates :body, presence: true
  belongs_to :user
  belongs_to :room
  after_create_commit { broadcast_append_to room }
end
