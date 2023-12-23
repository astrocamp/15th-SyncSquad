class List < ApplicationRecord

  # Relations
  belongs_to :projects
  has_many :tasks
end
