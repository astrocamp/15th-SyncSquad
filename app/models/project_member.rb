class ProjectMember < ApplicationRecord
  belongs_to :user
  belongs_to :project

  validates :title, presence: true
  validates :owner_id, presence: true
end
