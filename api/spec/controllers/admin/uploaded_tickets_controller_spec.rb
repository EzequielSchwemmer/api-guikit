describe Admin::UploadedTicketsController do
  let(:model_class_factory) { :ticket }

  include_examples 'administrate index examples'

  describe 'POST #review' do
    subject(:make_request) do
      post :review, params: request_params
    end

    let(:points_limit) { Rails.application.secrets.boost_points_limit }

    let(:request_params) do
      { id: ticket.id, uploaded_ticket: review_params }
    end
    let(:review_params) do
      {
        reward: { points: Faker::Number.between(1, points_limit).to_f.floor },
        ticket_code: Faker::Code.imei,
        emitted_at: Faker::Date.between(2.weeks.ago, 1.day.ago).to_datetime,
        reason_message: 'Correct Ticket'
      }
    end

    let(:ticket) { create(:ticket, :with_user, :with_pictures) }

    context 'when ticket is accepted' do
      include_context 'with admin user signed in'

      it 'renders the view with http status found' do
        make_request
        expect(response).to have_http_status(:found)
      end

      it 'redirects into index page' do
        make_request
        expect(response).to redirect_to action: :index
      end

      it 'changes the ticket status to reviewed' do
        make_request
        expect(ticket.reload.status).to eq('reviewed')
      end

      it 'creates a reward' do
        expect(&method(:make_request)).to change(Reward, :count).by(1)
      end
    end

    context 'when a ticket is rejected' do
      include_context 'with admin user signed in'

      let(:request_params) do
        { id: ticket.id, uploaded_ticket: review_params, reject: true }
      end
      let(:review_params) do
        {
          status: Ticket::REJECTED_STATUSES.sample,
          reward: { points: Faker::Number.between(1, points_limit).to_f.floor }
        }
      end

      it 'renders the view with http status found' do
        make_request
        expect(response).to have_http_status(:found)
      end

      it 'redirects into index page' do
        make_request
        expect(response).to redirect_to action: :index
      end

      it 'changes the ticket to rejected' do
        make_request
        expect(ticket.reload.rejected?).to be true
      end

      it 'creates a reward' do
        expect { make_request }.to change(Reward, :count).by(1)
      end
    end

    include_examples 'common admin authentication examples'
  end
end
