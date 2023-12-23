class Task < ApplicationRecord
  acts_as_paranoid

  # Relations
  belongs_to :lists
  has_many :users
end
