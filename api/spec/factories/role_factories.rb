FactoryBot.define do
  factory :role do
    name { Faker::Name.unique.name }

    trait :with_all_permissions do
      permissions do
        Permission.codes.values.map do |code|
          Permission.find_or_create_by!(code: code)
        end
      end
    end
  end
end
