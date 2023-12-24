class List < ApplicationRecord

  # Relations
  belongs_to :project
  has_many :tasks
end
