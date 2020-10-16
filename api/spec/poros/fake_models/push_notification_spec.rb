describe FakeModels::PushNotification, type: :model do
  subject(:push_notification) do
    described_class.new(
      body: Faker::Lorem.words(4),
      title: Faker::Lorem.words(10),
      user_ids: users.pluck(:id).to_a
    )
  end

  let(:users) { create_list(:user, 5) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:body) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user_ids) }
end
