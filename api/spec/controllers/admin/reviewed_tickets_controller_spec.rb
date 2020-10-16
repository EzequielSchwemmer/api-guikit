describe Admin::ReviewedTicketsController do
  let(:model_class_factory) { :reviewed_ticket }

  include_examples 'administrate index examples'

  describe '#recreate' do
    let(:ticket) { create(:reviewed_ticket) }
    let(:ticket_discount) { create(:ticket_discount, ticket: ticket) }
    let(:ticket_line_params) do
      attributes_for(:ticket_line).merge(product: attributes_for(:product))
    end
    let(:digitalize_params) do
      attributes_for(:ticket, :digitalized)
        .merge(
          retailer_attributes: attributes_for(:retailer),
          branch_attributes: attributes_for(:branch),
          ticket_line_attributes: [ticket_line_params]
        )
    end
    let(:params) { { id: ticket.id, reviewed_ticket: digitalize_params } }
    let(:make_request) { post :recreate, params: params }

    context 'when a valid digitalization is done' do
      include_context 'with admin user signed in'

      before do
        ticket_discount
        make_request
      end

      it 'responds with a found http status' do
        expect(response).to(have_http_status(:found))
      end

      it 'redirects into the index page' do
        expect(response).to redirect_to action: :index
      end

      it 'changes the ticket to rejected' do
        expect(ticket.reload.digitalized?).to be true
      end
    end

    context 'when an invalid digitalization is done' do
      include_context 'with admin user signed in'

      let(:digitalize_params) { attributes_for(:ticket, :digitalized) }

      before do
        make_request
      end

      it 'responds with http status unprocessable_entity' do
        expect(response).to(have_http_status(:unprocessable_entity))
      end

      it 'does not digitalize the ticket' do
        expect(ticket.reload.digitalized?).to be false
      end
    end

    context 'when a ticket is reverted' do
      include_context 'with admin user signed in'

      let(:params) { { id: ticket.id, revert: true } }

      before do
        make_request
      end

      it 'responds with a found http status' do
        expect(response).to(have_http_status(:found))
      end

      it 'redirects into the index page' do
        expect(response).to redirect_to action: :index
      end

      it 'changes the ticket to uploaded' do
        expect(ticket.reload.uploaded?).to be true
      end
    end
  end
end
