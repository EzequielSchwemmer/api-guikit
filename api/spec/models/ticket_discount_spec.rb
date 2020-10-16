describe TicketDiscount, type: :model do
  subject(:ticket_discount) { create(:ticket_discount) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:discount) }

  context 'when an invalid ticket discount is created' do
    subject(:ticket_discount) { build(:ticket_discount, discount: nil) }

    it { is_expected.not_to be_valid }
  end
end
