FactoryBot.define do
  factory :ticket do
    status { :uploaded }
    first_ticket { Faker::Boolean.boolean }

    transient do
      line_count { 5 }
    end

    after(:build) do |ticket|
      ticket.ticket_lines << FactoryBot.build(:ticket_line, ticket: ticket)
    end

    trait :with_pictures do
      after(:build) do |ticket|
        ticket.pictures.attach(
          io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'test_image.png')),
          filename: 'test_image.png', content_type: 'image/png'
        )
      end
    end

    trait :with_heavy_picture do
      after(:build) do |ticket|
        ticket.pictures.attach(
          io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'test_heavy_image.jpg')),
          filename: 'test_heavy_image.jpg', content_type: 'image/png'
        )
      end
    end

    trait :with_non_image_file do
      after(:build) do |ticket|
        ticket.pictures.attach(
          io: File.open(Rails.root.join('spec', 'support', 'fixtures', 'pdf_test.pdf')),
          filename: 'pdf_test.pdf'
        )
      end
    end

    trait :with_user do
      user

      before(:create) do |ticket|
        BankingInfo.delete_all
        FactoryBot.create(:banking_info, user: ticket.user)
      end
    end

    trait :with_user_without_banking_info do
      user
    end

    trait :with_lines do
      after(:create) do |ticket, evaluator|
        create_list(:ticket_line, evaluator.line_cont, ticket: ticket)
      end
    end

    trait :with_quick_review do
      status { 'reviewed' }
      quick_reviewer { create(:admin_user) }
      quick_reviewed_at { 1.day.ago }
      emitted_at { Faker::Date.between(2.weeks.ago, 1.day.ago).to_datetime }
      ticket_code { Faker::Code.imei }
      with_user
      with_pictures
    end

    trait :digitalized do
      total { Money.from_amount(Faker::Number.decimal(2).to_f) }
      status { :digitalized }
      retailer
      branch
      digitalizer { create(:admin_user) }
      digitalized_at { Date.current }
      with_user
      with_quick_review
      with_pictures
    end

    trait :with_segments_chosen do
      association :segments_chooser, factory: :admin_user
      segments_chosen_at { DateTime.current }
    end

    trait :approved do
      digitalized
      association :reviewer, factory: :admin_user
      refund_cents { Faker::Number.positive.to_i }
      reviewed_at { DateTime.current }
      status { :approved }
    end

    factory :reviewed_ticket do
      status { :reviewed }
      with_quick_review
      with_user
      with_pictures
    end

    factory :digitalized_ticket do
      digitalized
    end
  end
end
