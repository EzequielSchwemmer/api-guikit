FactoryBot.define do
  factory :discount do
    title { Faker::Commerce.product_name }
    discount_type { Faker::Commerce.product_name }
    description { Faker::Lorem.characters(70) }
    product_description { Faker::Lorem.characters(70) }
    cost { Faker::Types.rb_integer }
    terms_and_conditions { Faker::Lorem.paragraph }
    starts_at { Faker::Date.between(1.year.ago, 2.days.ago) }
    ends_at { Faker::Date.between(2.days.from_now, 2.months.from_now) }
    featured { Faker::Boolean.boolean }
    active { Faker::Boolean.boolean }

    transient do
      step_count { 3 }
    end

    trait :with_picture do
      after(:build) do |discount|
        discount.picture.attach(
          io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'test_image.png')),
          filename: 'test_image.png', content_type: 'image/png'
        )
      end
    end

    trait :active do
      active { true }
    end

    trait :with_errors do
      cost { nil }
      description { nil }
      title { nil }
    end

    trait :with_steps do
      after(:create) do |discount, evaluator|
        create_list(:discount_step, evaluator.step_count, discount: discount)
      end
    end

    factory :complete_discount do
      with_picture
    end
  end
end
