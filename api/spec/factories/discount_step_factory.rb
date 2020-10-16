FactoryBot.define do
  factory :discount_step do
    text { Faker::Lorem.sentence }
    position { Faker::Number.unique.between(1, 1_000_000) }

    trait :with_discount do
      association :discount, :with_picture
    end
  end
end
