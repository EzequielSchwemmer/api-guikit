FactoryBot.define do
  factory :product do
    code { Faker::Number.between(1_000, 10_000) }

    trait :with_errors do
      code { nil }
    end
  end
end
