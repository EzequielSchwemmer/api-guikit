describe PendingPayment do
  subject(:pending_payment) { described_class.find_by!(user: user) }

  let(:user) { create(:user) }
  let(:build_tickets) { create_list(:ticket, 5, :approved, user: user) }

  before do
    build_tickets
  end

  it { is_expected.to belong_to(:user) }
  it { is_expected.to have_many(:tickets) }

  describe '#total_refund' do
    let(:refund) { pending_payment.tickets.map(&:refund).reduce(:+) }

    it 'is equal to the sum of all ticket refunds' do
      expect(pending_payment.total_refund).to eq refund
    end
  end
end
