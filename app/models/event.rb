# frozen_string_literal: true

class Event < ApplicationRecord
  # 驗證
  validates :subject, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validate :end_must_after_start

  # 關聯
  belongs_to :company

  # 日期比對
  def end_must_after_start
    return unless started_at.present? && ended_at.present? && ended_at <= started_at

    errors.add(:ended_at, 'must after the start time')
  end

  # 行事曆格式
  def full_calendar_event
    {
      id:,
      title: subject,
      start: started_at,
      end: ended_at,
      allDay: all_day_event,
      description:
    }
  end
end
