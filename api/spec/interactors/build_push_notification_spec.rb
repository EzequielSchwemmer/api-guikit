describe BuildPushNotification do
  subject(:call_interactor) do
    described_class.call(title: title, body: body, user_ids: user_ids)
  end

  let(:title) { Faker::Name.name }
  let(:body) { Faker::Lorem.paragraph }
  let(:user_ids) { create_list(:user, 5).pluck(:id) }

  it { is_expected.to be_a_success }

  it 'has a push notification object inside the context' do
    expect(call_interactor.notification).to be_a(FakeModels::PushNotification)
  end

  it 'has a valid push notification' do
    expect(call_interactor.notification).to be_valid
  end

  context 'when invalid parameters are used' do
    let(:title) { nil }

    it { is_expected.to be_a_failure }

    it 'has a push notification object inside the context' do
      expect(call_interactor.notification).to be_a(FakeModels::PushNotification)
    end

    it 'has an invalid push notification' do
      expect(call_interactor.notification).not_to be_valid
    end
  end
end
