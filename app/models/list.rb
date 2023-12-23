class List < ApplicationRecord
  belongs_to :projects
  has_many :tasks
end
