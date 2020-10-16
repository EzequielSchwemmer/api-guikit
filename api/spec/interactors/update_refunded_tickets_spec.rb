describe UpdateRefundedTickets do
  describe '.call' do
    let(:context) { described_class.call(current_user: current_user, payments: payments) }
    let(:user) { create(:user) }
    let(:build_tickets) { create_list(:ticket, 5, :approved, user: user) }
    let(:current_user) { create(:admin_user) }
    let(:payments) do
      build_tickets
      PendingPayment.all
    end

    context 'when valid parameters are given' do
      it 'is a success' do
        expect(context).to be_a_success
      end

      it 'updates all the tickets as payd' do
        context
        expect(PendingPayment.count).to eq 0
      end
    end

    context 'when no payments are given' do
      let(:payments) { nil }

      it 'fails' do
        expect(context).not_to be_a_success
      end
    end
  end
end
