# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    subject { 'Example Event' }
    started_at { 1.day.from_now }
    ended_at { 2.days.from_now }
    all_day_event { false }
    description { 'Event Description' }
    association :company
  end
end
