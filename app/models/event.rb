class Event < ApplicationRecord
  
  validates :subject, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  belongs_to :user
end
