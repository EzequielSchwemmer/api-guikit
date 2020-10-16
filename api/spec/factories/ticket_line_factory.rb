FactoryBot.define do
  factory :ticket_line do
    product
    amount { Faker::Number.between(1, 10) }
    price { Money.new(Faker::Number.decimal(2), 'ARS') }
    discount_price { Money.new(Faker::Number.decimal(2), 'ARS') }

    trait :with_ticket do
      association :ticket, :with_pictures, :with_user
    end
  end
end
