describe Api::V1::BankingInfosController, type: :controller do
  describe 'POST #create' do
    subject(:req) { post :create, params: { banking_info: banking_info } }

    let(:model_klass) { BankingInfo }
    let(:schema_name) { 'banking_info' }
    let(:user) { create(:user) }
    let(:banking_info) { attributes_for(:banking_info) }

    context 'when creating a valid banking info' do
      include_context 'with customer signed in'
      it 'returns status code created' do
        req
        expect(response).to have_http_status(:created)
      end
    end

    context 'when banking info creation fails' do
      let(:banking_info) { attributes_for(:banking_info, bank_name: nil) }

      include_examples 'basic creation failure endpoint'
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end

  describe 'POST #update' do
    subject(:req) { put :update, params: { id: target_user.id, banking_info: banking_info } }

    let(:banking_info) { attributes_for(:banking_info) }

    context 'when a customer updates their banking info' do
      include_context 'with customer signed in'

      let(:target_user) { current_user }

      it 'responds with ok status' do
        req
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when a customer updates another customer\'s banking info' do
      let(:target_user) { create(:user) }

      it 'responds with unauthorized status' do
        req
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
