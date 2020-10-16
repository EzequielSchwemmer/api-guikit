describe Admin::AuditsController do
  describe '#new' do
    subject(:make_request) { get :new }

    context 'when an admin attemps to export audits' do
      include_context 'with admin user signed in'

      before do
        make_request
      end

      it 'responds with ok status' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe '#create' do
    subject(:make_request) { post :create, params: { audit: audit_params } }

    let(:audit_params) { { since: since, upto: upto, limit: 10, offset: 0 } }
    let(:since) { 2.days.ago }
    let(:upto) { Date.current }

    context 'when an admin exports audits' do
      include_context 'with admin user signed in'

      it 'responds with a ok http status' do
        make_request
        expect(response).to(have_http_status(:ok))
      end
    end

    context 'when since is newer than today' do
      include_context 'with admin user signed in'

      let(:upto) { 3.months.ago }

      it 'responds with unprocessable_entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
