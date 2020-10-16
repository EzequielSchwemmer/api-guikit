describe Api::V1::DiscountsController, type: :controller do
  describe 'GET #landing_discounts' do
    subject(:req) { get :landing_discounts }

    context 'when gets 12 random discounts' do
      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct json structure' do
        expected = load_fixture('landing_discounts')
        expect(response.body) =~ expected
      end
    end
  end

  describe 'GET #show' do
    subject(:req) { get :show, params: { id: discount_id } }

    let(:expected_data_keys) { %w[id type attributes] }
    let(:discount_id) { create(:discount, :with_picture).id }

    context 'when gets discount info' do
      include_context 'with customer signed in'

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when discount is not found' do
      let(:discount_id) { -1 }

      include_examples 'record not found'
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end
end
