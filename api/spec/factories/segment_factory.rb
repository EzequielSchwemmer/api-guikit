FactoryBot.define do
  factory :segment do
    name { Faker::Commerce.product_name }
  end
end
