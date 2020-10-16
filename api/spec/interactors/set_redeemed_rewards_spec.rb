describe SetRedeemedRewards do
  subject(:interactor) { described_class }

  let(:current_user) { create(:user, :with_banking_info) }
  let(:ticket) { create(:ticket, :with_pictures, user: current_user) }
  let(:discount) { create(:discount, :with_picture) }
  let(:ticket_discount) { create(:ticket_discount, ticket: ticket) }

  let(:interactor_context) do
    interactor.call(
      user: current_user
    )
  end

  context 'when a history contains redeemed discounts' do
    it 'succeeds' do
      expect(interactor_context).to be_a_success
    end

    it 'displays ticket discounts as rewards' do
      ticket_discount
      expect(interactor_context.redeemed_rewards.length).to eq(1)
    end
  end
end
