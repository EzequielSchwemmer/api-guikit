describe Admin::PendingPaymentsController do
  include_examples 'administrate index examples'

  describe '#export' do
    let(:make_request) { post :export, params: { pending_payments: params } }
    let(:params) { { payments: { '0' => payment } } }
    let(:payment) { { export: '1', user_id: user.id } }
    let(:user) { create(:user) }
    let(:build_tickets) { create_list(:ticket, 5, :approved, user: user) }
    let(:content_disposition) { response.header['Content-Disposition'] }

    context 'when a list of users are exported' do
      include_context 'with axlsx'
      include_context 'with admin user signed in'

      before do
        build_tickets
        make_request
      end

      it 'responds with http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'sends an xls spreadsheet' do
        expect(response.content_type).to eq(xls_content_type)
      end

      it 'sends an attachment' do
        expect(content_disposition).to eq('attachment; filename="payments.xlsx"')
      end
    end

    context 'when invalid parameters are given as exports' do
      include_context 'with admin user signed in'

      let(:payment) { [] }

      before do
        build_tickets
      end

      it 'raises an error' do
        expect { make_request }.to raise_error(ActionController::ParameterMissing)
      end
    end

    include_examples 'common admin authentication examples'
  end
end
