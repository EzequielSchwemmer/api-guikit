describe SaveTicketDiscounts do
  subject(:action) do
    described_class.call(current_user: current_user, params: params, ticket: ticket)
  end

  let(:current_user) { create(:admin_user) }
  let(:params) { { refund: Faker::Number.between(0, Ticket::MAX_REFUND).to_f / 100 } }
  let(:ticket) { create(:digitalized_ticket) }

  it 'is a success' do
    expect(action).to be_a_success
  end

  it 'approves the ticket' do
    action
    expect(ticket.status).to eq 'approved'
  end

  context 'when invalid parameters are valid' do
    let(:params) { { refund: Faker::Number.negative.to_f } }

    it 'is a failure' do
      expect(action).to be_a_failure
    end
  end
end
