describe Api::V1::UsersController do
  let(:user) { create(:user) }

  describe 'GET #show' do
    subject(:req) { get :show }

    let(:expected_data_keys) { %w[id type attributes relationships] }
    let(:expected_included_keys) { %w[id type attributes] }

    context 'when gets current user info' do
      include_context 'with customer signed in'

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'JSON body response contains expected data' do
        req
        json_response = JSON.parse(response.body)
        attributes = json_response['data']
        expect(attributes.keys).to match_array(expected_data_keys)
      end

      it 'JSON body response contains expected included' do
        FactoryBot.create :banking_info, user: current_user
        req
        json_response = JSON.parse(response.body)
        attributes = json_response['included'].first
        expect(attributes.keys).to match_array(expected_included_keys)
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end

  describe 'PUT #update' do
    subject(:req) { put :update, params: { id: target_user.id, user: params } }

    let(:params) { attributes_for(:user) }

    context 'when customer makes changes to their profile' do
      include_context 'with customer signed in'

      let(:target_user) { current_user }

      it 'responds with ok status' do
        req
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when a customer attemps to change other user\'s profile' do
      let(:target_user) { user }

      it 'responds with unauthorized status' do
        req
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
