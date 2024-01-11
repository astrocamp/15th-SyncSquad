# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

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

  def avatar_thumbnail
    resize_avatar(150, 150)
  end

  def chat_avatar
    resize_avatar(35, 35)
  end

  # omniauth for Gmail
  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.full_name = auth.info.name
    end
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

  def self.ransackable_attributes(_auth_object = nil)
    %w[name email]
  end
end
