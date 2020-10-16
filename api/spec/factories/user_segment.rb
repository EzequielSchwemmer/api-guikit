FactoryBot.define do
  factory :user_segment do
    association :segment
    association :user
  end
end
