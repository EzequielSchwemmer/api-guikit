FactoryBot.define do
  factory :discount_segment do
    association :segment
    association :discount, :with_picture, :active
  end
end
