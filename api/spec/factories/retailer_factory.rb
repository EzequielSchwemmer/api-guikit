FactoryBot.define do
  factory :retailer do
    transient do
      branch_count { 10 }
    end

    name { Faker::Commerce.product_name }

    trait :with_branches do
      after(:create) do |retailer, evaluator|
        create_list(:branch, evaluator.branch_count, retailer: retailer)
      end
    end
  end
end
