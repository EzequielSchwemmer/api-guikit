describe Admin::PushNotificationsController do
  describe 'GET #new' do
    let(:make_request) { get :new }

    context 'when admin is signed in' do
      include_context 'with admin user signed in'

      before { make_request }

      it 'responds with ok status' do
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples 'common admin authentication examples'
  end

  describe 'POST #create' do
    let(:make_request) { post :create, params: { push_notification: params } }
    let(:params) do
      {
        user_ids: ['', *users.pluck(:id)],
        title: Faker::Lorem.words(4).join(' '),
        body: Faker::Lorem.words(10).join(' ')
      }
    end
    let(:users) { create_list(:user, 5) }

    context 'when valid push notifications are sent' do
      include_context 'with admin user signed in'

      before { make_request }

      it 'responds with found status' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new action' do
        expect(response).to redirect_to action: :new
      end
    end

    context 'when an invalid title is sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          user_ids: ['', *users.pluck(:id)],
          title: '',
          body: Faker::Lorem.words(10).join(' ')
        }
      end

      before { make_request }

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when an invalid body is sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          user_ids: ['', *users.pluck(:id)],
          title: Faker::Lorem.words(4).join(' '),
          body: ''
        }
      end

      before { make_request }

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'when an invalid users are sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          user_ids: [],
          title: Faker::Lorem.words(4).join(' '),
          body: Faker::Lorem.words(10).join(' ')
        }
      end

      before { make_request }

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    include_examples 'common admin authentication examples'
  end

  describe 'POST #create_segment_notification' do
    let(:make_request) do
      post :create_segment_notification, params: { segment_push_notification: params }
    end

    let(:params) do
      {
        segment_ids: ['', *segments.pluck(:id)],
        title: Faker::Lorem.words(4).join(' '),
        body: Faker::Lorem.words(10).join(' ')
      }
    end
    let(:segments) { create_list(:segment, 5) }

    context 'when valid push notifications are sent' do
      include_context 'with admin user signed in'

      before { make_request }

      it 'responds with found status' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects to new action' do
        expect(response).to redirect_to action: :new
      end
    end

    context 'when an invalid title is sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          segment_ids: ['', *segments.pluck(:id)],
          title: '',
          body: Faker::Lorem.words(10).join(' ')
        }
      end

      before { make_request }

      it 'responds with error flash' do
        expect(flash[:error]).to match(I18n.t('admin.actions.push_notifications.failed'))
      end
    end

    context 'when an invalid body is sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          segment_ids: ['', *segments.pluck(:id)],
          title: Faker::Lorem.words(4).join(' '),
          body: ''
        }
      end

      before { make_request }

      it 'responds with error flash' do
        expect(flash[:error]).to match(I18n.t('admin.actions.push_notifications.failed'))
      end
    end

    context 'when an invalid users are sent' do
      include_context 'with admin user signed in'

      let(:params) do
        {
          segment_ids: [],
          title: Faker::Lorem.words(4).join(' '),
          body: Faker::Lorem.words(10).join(' ')
        }
      end

      before { make_request }

      it 'responds with error flash' do
        expect(flash[:error]).to match(I18n.t('admin.actions.push_notifications.failed'))
      end
    end

    include_examples 'common admin authentication examples'
  end
end
