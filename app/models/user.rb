# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  enum role: { staff: 0, hr: 1 }
  # Relationship
  belongs_to :company, optional: true
  has_many :events
  has_many :project_members, dependent: :destroy
  has_many :affiliated_projects, through: :project_members, source: :project
  has_many :tasks

  # Chatroom messages
  scope :all_except, ->(user) { where.not(id: user) }
  after_create_commit { broadcast_append_to 'users' }

  has_many :messages

  # Chatroom avatar
  has_one_attached :avatar

  after_commit :add_default_avatar, on: %i[create update]

  # Project
  has_many :project_members, dependent: :destroy
  has_many :affiliated_projects, through: :project_members, source: :project
  has_many :tasks
  has_many :task_responsible_people, dependent: :destroy
  has_many :in_charge_of_tasks, through: :task_responsible_people, source: :task
  
  def avatar_thumbnail
    resize_avatar(150, 150)
  end

  def chat_avatar
    resize_avatar(35, 35)
  end

  private

  def resize_avatar(width, height)
    resized_avatar = avatar.variant(resize_to_limit: [width, height])

    if resized_avatar.send(:processed?)
      resized_avatar.processed
    else
      resized_avatar
    end
  end

  def add_default_avatar
    return if avatar.attached?

    avatar.attach(
      io: File.open(Rails.root.join('app', 'assets', 'images', 'default_profile.png')),
      filename: 'default_profile.png',
      content_type: 'image/png'
    )
  end
end
