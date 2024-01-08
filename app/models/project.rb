# frozen_string_literal: true

class Project < ApplicationRecord
  acts_as_paranoid
  scope :owned_by_user, ->(user) { where(user_id: user.id) }

  # Relations
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user
  has_many :lists, dependent: :destroy
  has_many :tasks, through: :lists

  # Validates
  validates :title, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at deleted_at description id owner_id title updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ['owner']
  end
end
