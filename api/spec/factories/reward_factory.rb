FactoryBot.define do
  factory(:reward) do
    points { Faker::Number.between(1, Rails.application.secrets.boost_points_limit) }

    trait :with_user do
      user { create(:user) }
    end
  end
end
