FactoryBot.define do
  factory :admin_user do
    email { Faker::Internet.email }
    password { "Aa1@#{Faker::Alphanumeric.alphanumeric(10)}" }
    name { Faker::Name.first_name }
    birthday { Faker::Date.birthday }
    role { create(:role, :with_all_permissions) }
  end
end
