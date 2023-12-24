class List < ApplicationRecord

  # Relations
  belongs_to :project
  has_many :tasks

  # Validates
  validates :title, presence: true
end
