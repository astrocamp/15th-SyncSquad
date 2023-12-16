class Event < ApplicationRecord
  # 驗證
  validates :subject, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  # 關聯
  belongs_to :user
end
