describe Api::V1::PointsController, type: :controller do
  describe 'GET #current_points' do
    subject(:req) { get :current_points }

    context 'when gets current user points' do
      include_context 'with customer signed in'

      before do
        allow(Points::CurrentPointsCalculator).to receive(:current_user)
          .and_return(JSON.parse(load_fixture('points')))
        req
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct json structure' do
        expected = load_fixture('points')
        expect(response.body) =~ expected
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end

  describe 'GET #history' do
    subject(:req) { get :history }

    context 'when gets current user history' do
      include_context 'with customer signed in'

      it 'responds with 200 status' do
        req
        expect(response).to have_http_status(:ok)
      end

      it 'responds with correct json structure' do
        req
        expected = load_fixture('history')
        expect(response.body) =~ expected
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end
end
