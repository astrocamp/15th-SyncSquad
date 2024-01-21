# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@test.company.com' }
    password { '123456' }
    role { 'hr' }
    association :company
  end
end
