# frozen_string_literal: true

class Task < ApplicationRecord
  acts_as_paranoid
  after_initialize :set_defaults

  # Rank
  include RankedModel
  ranks :row_order, with_same: :list_id

  # Relations
  belongs_to :list
  delegate :project, to: :list
  belongs_to :user, optional: true
  has_many :comments

  # Validates
  validates :title, presence: true
  validate :ended_at_must_after_started_at

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

  PRIORITY = {
    critical: 1,
    high: 2,
    medium: 3,
    low: 4
  }.freeze
  enum priority: PRIORITY

  def set_defaults
    priority = 3
    started_date = Date.current
    ended_date = Date.current
  end

  def ended_at_must_after_started_at
    return unless ended_at.present? && started_at.present? && ended_at < started_at

    errors.add(:ended_at, 'must be after the start time')
  end
end
