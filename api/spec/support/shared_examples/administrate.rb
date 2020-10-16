shared_examples 'administrate index examples' do
  describe 'GET #index' do
    let(:make_request) { get :index }
    let(:model) { create(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with ok status' do
        make_request
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples 'common admin authentication examples'
  end
end

shared_examples 'administrate show examples' do
  describe 'GET #show' do
    let(:make_request) { get :show, params: { id: model.id } }
    let(:model) { create(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with ok status' do
        make_request
        expect(response).to have_http_status(:ok)
      end
    end

    include_examples 'common admin authentication examples'
  end
end

shared_examples 'administrate create examples' do
  describe 'POST #create' do
    let(:make_request) { post :create, params: { param_key => attributes } }
    let(:param_key) { respond_to?(:attribute_param) ? attribute_param : model_class_factory }
    let(:attributes) { attributes_for(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with found status' do
        make_request
        expect(response).to have_http_status(:found)
      end
    end

    include_examples 'common admin authentication examples'
  end
end

shared_examples 'administrate update examples' do
  describe 'PUT #update' do
    let(:make_request) do
      put :update, params: { id: model.id, param_key => attributes }
    end
    let(:param_key) { respond_to?(:attribute_param) ? attribute_param : model_class_factory }
    let(:model) { create(model_class_factory) }
    let(:attributes) { attributes_for(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with found status' do
        make_request
        expect(response).to have_http_status(:found)
      end
    end

    include_examples 'common admin authentication examples'
  end
end

shared_examples 'administrate destroy examples' do
  describe 'DELETE #destroy' do
    let(:make_request) { delete :destroy, params: { id: model.id } }
    let(:model) { create(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with found status' do
        make_request
        expect(response).to have_http_status(:found)
      end
    end

    include_examples 'common admin authentication examples'
  end
end

shared_examples 'administrate full example set' do
  include_examples 'administrate index examples'
  include_examples 'administrate show examples'
  include_examples 'administrate create examples'
  include_examples 'administrate update examples'
  include_examples 'administrate destroy examples'
end

shared_examples 'unauthorized show admin examples' do
  describe 'GET #show' do
    let(:make_request) { get :show, params: { id: model.id } }
    let(:model) { create(model_class_factory) }

    context 'when an admin is signed in' do
      include_context 'with admin user signed in'

      it 'responds with unauthorized status' do
        expect(&method(:make_request)).to raise_error(Pundit::NotAuthorizedError)
      end
    end

    include_examples 'common admin authentication examples'
  end
end
