describe Admin::DatabaseController do
  describe 'GET #show' do
    let(:make_request) { get :show }

    include_examples 'common admin authentication examples'

    context 'when an admin attemps to view the export' do
      it 'renders the view with http status ok' do
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #export' do
    include_context 'with axlsx'

    let(:exports) { { user: true } }
    let(:make_request) { post :export, params: { export: exports } }

    include_examples 'common admin authentication examples'

    context 'when valid params are sent' do
      include_context 'with admin user signed in'

      let(:content_disposition) { response.header['Content-Disposition'] }

      before do
        make_request
      end

      it 'responds with http status ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'sends an xls spreadsheet' do
        expect(response.content_type).to eq(xls_content_type)
      end

      it 'sends an attachment' do
        expect(content_disposition).to eq('attachment; filename="database.xlsx"')
      end
    end

    context 'when invalid options are sent' do
      include_context 'with admin user signed in'

      let(:params) { { export: exports, options: { limit: 0 } } }
      let(:make_request) { post :export, params: params }
      let(:content_disposition) { response.header['Content-Disposition'] }

      before do
        make_request
      end

      it 'responds with unprocessable_entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not send an attachment' do
        expect(content_disposition).not_to eq('attachment; filename="database.xlsx"')
      end
    end
  end
end
