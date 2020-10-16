FactoryBot.define do
  factory :user_discount do
    association :user
    association :discount, :with_picture

    trait :with_errors do
      association :user, strategy: :null
      association :discount, strategy: :null
    end
  end
end
