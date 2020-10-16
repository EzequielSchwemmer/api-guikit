FactoryBot.define do
  factory :banking_info do
    bank_name { Faker::Bank.name }
    bank_alias { Faker::Alphanumeric.alphanumeric 10 }
    cuit { Faker::Number.number(11) }
    cbu { Faker::Number.number(22) }
    association :user

    trait :no_cbu_alias do
      cbu { nil }
      bank_alias { nil }
    end

    trait :with_errors do
      bank_name { nil }
      bank_alias { 'bbb' }
      cuit { nil }
      cbu { 'ccc' }
      association :user, strategy: :null
    end

    trait :with_holder do
      holder { false }
      holder_name { Faker::Name.first_name }
    end

    trait :without_holder do
      holder { true }
    end
  end
end
