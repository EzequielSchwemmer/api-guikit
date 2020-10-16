FactoryBot.define do
  factory :ticket_discount do
    association :ticket, :with_pictures, :with_user
    association :discount, :with_picture

    trait :without_banking_info do
      association :ticket, :with_user_without_banking_info, :with_pictures
    end
  end
end
