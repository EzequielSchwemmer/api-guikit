describe Admin::RewardsController do
  describe '#new' do
    subject(:make_request) { get :new }

    context 'when an admin attemps to make a new reward' do
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
    subject(:make_request) { post :create, params: { reward: reward_params } }

    let(:reward_params) { { user_ids: user_ids, concept: concept, points: points, notify: true } }
    let(:user_ids) { [create(:user).id] }
    let(:concept) { 'Entrevista realizada en un Lugar' }
    let(:points) { Faker::Number.between(1, Rails.application.secrets.boost_points_limit - 1) }

    context 'when an admin attemps to make a new reward' do
      include_context 'with admin user signed in'

      it 'responds with a found http status' do
        make_request
        expect(response).to(have_http_status(:found))
      end

      it 'redirects into the index page' do
        make_request
        expect(response).to redirect_to action: :new
      end

      it 'creates a new reward' do
        expect { make_request }.to change(Reward, :count).by(1)
      end
    end

    context 'when an admin sends an invalid concept' do
      include_context 'with admin user signed in'

      let(:concept) { nil }

      it 'responds with unprocessable_entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new reward' do
        expect { make_request }.not_to change(Reward, :count)
      end
    end

    context 'when an admin sends invalid users' do
      include_context 'with admin user signed in'

      let(:user_ids) { nil }

      it 'responds with unprocessable_entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new reward' do
        expect { make_request }.not_to change(Reward, :count)
      end
    end

    context 'when an admin sends invalid points' do
      include_context 'with admin user signed in'

      let(:points) { nil }

      it 'responds with unprocessable_entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new reward' do
        expect { make_request }.not_to change(Reward, :count)
      end
    end
  end
end
