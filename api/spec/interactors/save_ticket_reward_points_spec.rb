describe SaveTicketRewardPoints do
  subject(:context) do
    described_class.call user: current_user, ticket: ticket
  end

  let(:ticket) do
    InitializeTicket.call(user: current_user, params: ticket_params).ticket
  end

  describe '.call' do
    context 'when a ticket is correctly created' do
      let(:ticket_params) do
        attributes_for(:ticket, user: current_user).merge(
          pictures: [fixture_file_upload('spec/support/fixtures/test_image.png')]
        )
      end
      let(:current_user) { create(:user, :with_banking_info) }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'creates reward' do
        expect { context }.to change(Reward, :count).by(1)
      end
    end
  end
end
