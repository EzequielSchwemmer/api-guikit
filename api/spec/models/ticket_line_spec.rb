describe TicketLine do
  subject(:line) { create(:ticket_line, :with_ticket) }

  it { is_expected.to belong_to(:ticket) }
  it { is_expected.to validate_presence_of(:product) }
  it { is_expected.to validate_presence_of(:amount) }
  it { is_expected.to validate_presence_of(:price_cents) }
  it { is_expected.to validate_presence_of(:discount_price_cents) }
  it { is_expected.to validate_numericality_of(:amount) }
  it { is_expected.to validate_numericality_of(:price_cents) }
  it { is_expected.to validate_numericality_of(:discount_price_cents) }
end
