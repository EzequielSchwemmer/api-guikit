FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "Aa1@#{Faker::Alphanumeric.alphanumeric(10)}" }
    name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    dni { Faker::IDNumber.south_african_id_number }
    birthday { Faker::Date.birthday }
    gender { User.genders.keys.sample }
    confirmed_at { DateTime.current }

    trait :with_errors do
      email { nil }
      name { nil }
      birthday { nil }
    end

    trait :with_banking_info do
      before(:create) do |user|
        FactoryBot.create(:banking_info, user: user)
      end
    end
  end
end
