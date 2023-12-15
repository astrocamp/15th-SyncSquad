<<<<<<< HEAD
# frozen_string_literal: true

class Project < ApplicationRecord
  scope :owned_by_user, ->(user) { where(user_id: user.id) }

  # Relations
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'
  has_many :project_members, dependent: :destroy
  has_many :members, through: :project_members, source: :user

  # Validates
  validates :title, presence: true
  validates :owner_id, numericality: { only_integer: true }
=======
class Project < ApplicationRecord
    scope :owned_by_user, ->(user) { where(user_id: user.id) }

    # Relations
    belongs_to :owner, class_name: 'User', foreign_key: 'owner_id'

    # Validates
    validates :title, presence: true
    validates :owner, presence: true
>>>>>>> f0f59f3 (WIP: project CRUD)
end
