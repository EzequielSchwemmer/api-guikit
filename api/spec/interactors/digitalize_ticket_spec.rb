describe DigitalizeTicket do
  subject(:interactor) { described_class }

  let(:ticket) { create(:ticket, :with_user, :with_pictures) }
  let(:ticket_with_discount) { create(:ticket, :with_user, :with_pictures) }
  let(:ticket_discount) { create(:ticket_discount, ticket: ticket_with_discount) }
  let(:current_user) { create(:admin_user) }
  let(:ticket_line_params) do
    attributes_for(:ticket_line).merge(product: attributes_for(:product))
  end
  let(:line_params) { { ticket_line_attributes: [ticket_line_params] } }
  let(:params) do
    attributes_for(:ticket, :digitalized)
      .merge(line_params)
      .merge(retailer_attributes: attributes_for(:retailer))
      .merge(branch_attributes: attributes_for(:branch))
  end
  let(:interactor_context) do
    interactor.call(
      params: params,
      current_user: current_user,
      ticket: ticket
    )
  end

  let(:interactor_context_with_discounts) do
    interactor.call(
      params: params,
      current_user: current_user,
      ticket: ticket_with_discount
    )
  end

  describe '.call' do
    context 'with correct parameters and ticket without discounts' do
      it 'does not fail' do
        expect(interactor_context.success?).to be true
      end

      it 'sets the ticket as valid' do
        interactor_context
        expect(ticket.valid?).to be true
      end

      it 'sets the ticket to paid' do
        interactor_context
        expect(ticket.status).to eq 'paid'
      end
    end

    context 'with correct parameters and ticket with discounts' do
      it 'does not fail' do
        expect(interactor_context_with_discounts.success?).to be true
      end

      it 'sets the ticket as valid' do
        interactor_context_with_discounts
        expect(ticket_with_discount.valid?).to be true
      end

      it 'sets the ticket to digitalized' do
        ticket_discount
        interactor_context_with_discounts
        expect(ticket_with_discount.status).to eq 'digitalized'
      end
    end

    context 'with incorrect parameters' do
      let(:params) { {} }

      it 'sets the ticket invalid' do
        interactor_context
        expect(ticket.valid?).to be false
      end

      it 'fails' do
        expect(interactor_context.success?).to be false
      end
    end
  end
end
