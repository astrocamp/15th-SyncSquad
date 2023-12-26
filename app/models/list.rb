class List < ApplicationRecord

  # Rank
  include RankedModel
  ranks :row_order

  # Relations
  belongs_to :project
  has_many :tasks, dependent: :destroy

  # Validates
  validates :title, presence: true
end
