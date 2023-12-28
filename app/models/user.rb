# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Relationship
  belongs_to :company, optional: true
  has_many :events

  # Chatroom
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }
  has_many :messages
  has_many :project_members, dependent: :destroy
  has_many :affiliated_projects, through: :project_members, source: :project
end
