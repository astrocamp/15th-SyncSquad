class Task < ApplicationRecord
  acts_as_paranoid

  # Relations
  belongs_to :list
  has_many :users
  has_many :task_responsible_people, dependent: :destroy
  has_many :responsible_users ,through: :task_responsible_people, source: :user

  # Validates
  validates :title, presence: :true
end
