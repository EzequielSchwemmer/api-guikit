describe Api::V1::UserDiscountsController, type: :controller do
  describe 'GET #index' do
    subject(:req) { get :index }

    let(:discount) { create(:discount, :with_picture) }
    let(:expected_data_keys) { %w[id type relationships] }
    let(:expected_included_keys) { %w[id type attributes] }
    let(:expected_meta_keys) { %w[total_pages current_page] }
    let(:record) { UserDiscount.create(user: current_user, discount: discount) }
    let(:params) { { current_user: current_user } }

    context 'when gets list of current user discounts' do
      include_context 'with customer signed in'

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct json structure' do
        expected = load_fixture('available_discounts')
        expect(response.body) =~ expected
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end

  describe 'GET #obtained_discounts' do
    subject(:req) { get :obtained_discounts }

    let(:expected_data_keys) { %w[id type relationships] }
    let(:expected_included_keys) { %w[id type attributes] }
    let(:expected_meta_keys) { %w[total_pages current_page] }
    let(:ticket) { FactoryBot.create :ticket, :with_pictures, user: current_user }
    let(:record) { FactoryBot.create :ticket_discount, ticket: ticket }

    context 'when gets list of current user discounts' do
      include_context 'with customer signed in'

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct json structure' do
        expected = load_fixture('obtained_discounts')
        expect(response.body) =~ expected
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end
end
