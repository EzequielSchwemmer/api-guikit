describe SaveFirstTicketRewardPoints do
  subject(:context) do
    described_class.call user: current_user, params: ticket_params
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

      it 'provides ticket' do
        expect(context.ticket).to eq(Ticket.last)
      end

      it 'creates ticket' do
        expect { context }.to change(Ticket, :count).by(1)
      end

      it 'creates reward' do
        expect { context }.to change(Reward, :count).by(1)
      end
    end
  end
end
