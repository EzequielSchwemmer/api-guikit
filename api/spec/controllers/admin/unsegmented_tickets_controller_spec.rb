describe Admin::UnsegmentedTicketsController do
  let(:model_class_factory) { :digitalized_ticket }

  include_examples 'administrate index examples'
  include_examples 'administrate show examples'

  describe 'POST #assign_segments' do
    let(:make_request) { post :assign_segments, params: { id: ticket.id, user: user_params } }
    let(:user_params) { { segment_ids: segments.pluck(:id) } }
    let(:ticket) { create(:digitalized_ticket) }
    let(:segments) { create_list(:segment, 5) }

    context 'when valid segments are given' do
      include_context 'with admin user signed in'

      before do
        make_request
      end

      it 'responds with http status found' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to index action' do
        expect(response).to redirect_to action: :index
      end

      it 'updates the segments for the user of the ticket' do
        expect(ticket.user.reload.segments).to match_array(segments)
      end
    end

    context 'when an empty list of segments are given' do
      include_context 'with admin user signed in'

      # Rails does this for empty id arrays, to avoid converting [] into nil
      let(:user_params) { { segment_ids: [''] } }

      before do
        make_request
      end

      it 'responds with http status found' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to index action' do
        expect(response).to redirect_to action: :index
      end

      it 'updates the segments for the user of the ticket' do
        expect(ticket.user.reload.segments).to match_array([])
      end
    end

    context 'when invalid segments are given' do
      include_context 'with admin user signed in'

      let(:user_params) { { segment_ids: nil } }

      before do
        make_request
      end

      it 'responds with unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not update the segments of the user' do
        expect(ticket.user.reload.segments).not_to match_array(segments)
      end
    end

    include_examples 'common admin authentication examples'
  end
end
