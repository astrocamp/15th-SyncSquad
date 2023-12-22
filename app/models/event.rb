# frozen_string_literal: true

class Event < ApplicationRecord
  # 驗證
  validates :subject, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :end_must_after_start

  # 關聯
  belongs_to :user

  # 時間跟日期組合
  def local_start_datetime(date, time)
    Time.zone.parse("#{date} #{time}")
  end

  # 日期比對
  def end_must_after_start
    start_at = local_start_datetime(start_date, start_time)
    end_at = local_start_datetime(end_date, end_time)
    return unless end_at < start_at

    errors.add(:end_date, 'must after the start time')
  end

  # 行事曆格式
  def full_calendar_event
    {
      id:,
      title: subject,
      start: local_start_datetime(start_date, start_time),
      end: local_start_datetime(end_date, end_time),
      allDay: all_day_event,
      description:
    }
  end
end
