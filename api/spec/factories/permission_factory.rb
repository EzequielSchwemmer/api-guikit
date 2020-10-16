FactoryBot.define do
  factory :permission do
    code { Permission.codes.values.sample }
  end
end
