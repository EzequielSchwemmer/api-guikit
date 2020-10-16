FactoryBot.define do
  factory :branch do
    name { Faker::Commerce.product_name }
    retailer
  end
end
