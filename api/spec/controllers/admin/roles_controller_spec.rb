describe Admin::RolesController do
  let(:model_class_factory) { :role }

  include_examples 'administrate index examples'
  include_examples 'administrate show examples'

  describe '#new' do
    subject(:make_request) { get :new }

    context 'when an admin is authenticated' do
      include_context 'with admin user signed in'

      it 'renders the view with http status ok' do
        make_request
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples 'common admin authentication examples'
  end

  describe '#create' do
    subject(:make_request) { post :create, params: { role: params } }

    let(:params) { { name: Faker::Name.name } }

    context 'with correct parameters' do
      include_context 'with admin user signed in'

      let(:params) { { name: Faker::Name.name, permissions: {} } }

      it 'responds with found http status' do
        make_request
        expect(response).to have_http_status(:found)
      end

      it 'creates a new role' do
        expect { make_request }.to change(Role, :count).by(1)
      end
    end

    context 'with correct permissions' do
      include_context 'with admin user signed in'

      let(:params) do
        { name: Faker::Name.name, permissions: { permission => Faker::Boolean.boolean } }
      end
      let(:permission) { Permission.codes.keys.sample }

      it 'responds with found http status' do
        make_request
        expect(response).to have_http_status(:found)
      end

      it 'creates a new role' do
        expect { make_request }.to change(Role, :count).by(1)
      end
    end

    context 'with incorrect parameters' do
      include_context 'with admin user signed in'

      let(:params) { { name: '', permissions: {} } }

      it 'responds with unprocessable_entity http status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a new role' do
        expect { make_request }.not_to change(Role, :count)
      end
    end

    include_examples 'common admin authentication examples'
  end

  describe '#edit' do
    subject(:make_request) { post :create, params: { id: role.id } }

    let(:role) { create(:role) }

    it 'responds with ok http status' do
      expect(response).to have_http_status(:ok)
    end

    include_examples 'common admin authentication examples'
  end

  describe '#update' do
    subject(:make_request) { post :create, params: { id: role.id, role: params } }

    let(:role) { create(:role) }
    let(:params) { { name: Faker::Name.name } }

    context 'with correct parameters' do
      include_context 'with admin user signed in'

      let(:params) { { name: Faker::Name.name, permissions: {} } }

      it 'responds with found http status' do
        make_request
        expect(response).to have_http_status(:found)
      end
    end

    context 'with incorrect parameters' do
      include_context 'with admin user signed in'

      let(:params) { { name: '', permissions: {} } }

      it 'responds with unprocessable_entity http status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    include_examples 'common admin authentication examples'
  end
end
