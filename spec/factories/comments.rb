FactoryBot.define do
  factory :comment do
    content { 'Default Comment Content' }
    user { FactoryBot.build(:user) }
    task { FactoryBot.build(:task) }
  end
end