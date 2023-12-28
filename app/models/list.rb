# frozen_string_literal: true

class List < ApplicationRecord
  acts_as_paranoid

  # Rank
  include RankedModel
  ranks :row_order, with_same: :project_id

  # Relations
  belongs_to :project
  has_many :tasks, dependent: :destroy

  # Validates
  validates :title, presence: true
end
