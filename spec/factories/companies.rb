# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { 'test' }
    email { 'test@company.com' }
    password { '123456' }
  end
end
