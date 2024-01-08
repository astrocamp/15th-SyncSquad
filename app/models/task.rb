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

  # Validates
  validates :title, presence: true
  validate :end_must_after_start
  validate :validate!

  PRIORITY = {
    critical: 1,
    high: 2,
    medium: 3,
    low: 4
  }.freeze
  enum priority: PRIORITY

  def set_defaults
    priority = 3
    start_date = Date.current
    end_date = Date.current
  end

  def validate!
    errors.add(:title, :blank, message: "cannot be nil") if title.nil?
  end

  # 時間跟日期組合
  def local_start_datetime(date, time)
    Time.zone.parse("#{date} #{time}")
  end

  # 日期比對
  def end_must_after_start
    start_at = local_start_datetime(start_date, start_datetime)
    end_at = local_start_datetime(end_date, end_datetime)
    return unless end_at.present? && start_at.present? && end_at < start_at

    errors.add(:end_date, 'must after the start time')
  end

  # # 行事曆格式
  # def full_calendar_event
  #   {
  #     id:,
  #     title: subject,
  #     start: local_start_datetime(start_date, start_time),
  #     end: local_start_datetime(end_date, end_time),
  #     allDay: all_day_event,
  #     description:
  #   }
  # end
end
