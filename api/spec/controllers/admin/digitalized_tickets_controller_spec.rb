describe Admin::DigitalizedTicketsController do
  let(:model_class_factory) { :digitalized_ticket }

  include_examples 'administrate index examples'
  include_examples 'administrate show examples'

  describe 'POST #review' do
    let(:make_request) { post :review, params: { id: ticket.id, digitalized_ticket: params } }
    let(:params) { {} }
    let(:ticket) { create(:digitalized_ticket) }

    context 'when an admin sends a request with valid parameters' do
      include_context 'with admin user signed in'

      let(:params) { { refund: Faker::Number.between(0, Ticket::MAX_REFUND).to_f / 100 } }

      before do
        make_request
      end

      it 'responds with http action found' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects into the index page' do
        expect(response).to redirect_to action: :index
      end

      it 'sets the current reviewer as the current user' do
        expect(ticket.reload.reviewer).to eq current_user
      end

      it 'marks the ticket as approved' do
        expect(ticket.reload.status).to eq 'approved'
      end
    end

    context 'when an admin sends invalid parameters' do
      include_context 'with admin user signed in'

      let(:params) { { refund: Faker::Number.negative.to_f } }

      before do
        make_request
      end

      it 'redirects back to show' do
        expect(response).to redirect_to admin_root_path
      end
    end

    include_examples 'common admin authentication examples'
  end
end
