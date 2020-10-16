describe Admin::DiscountsController do
  let(:model_class_factory) { :complete_discount }
  let(:attribute_param) { :discount }

  include_examples 'administrate index examples'
  include_examples 'administrate show examples'
  include_examples 'administrate update examples'
  include_examples 'administrate destroy examples'

  describe '#create' do
    subject(:make_request) { post :create, params: params }

    let(:discount_params) do
      attributes_for(:discount)
        .merge(
          picture: fixture_file_upload('spec/support/fixtures/test_image.png')
        )
    end
    let(:params) { { discount: discount_params } }

    include_context 'with admin user signed in'

    context 'when valid params are given' do
      it 'creates a new discount' do
        expect { make_request }.to change(Discount, :count).by(1)
      end

      it 'renders the view with http status found' do
        make_request
        expect(response).to have_http_status(:found)
      end
    end

    context 'when invalid params are given' do
      let(:discount_params) { attributes_for(:discount, starts_at: nil) }

      it 'does not create a new discount' do
        expect { make_request }.not_to change(Discount, :count)
      end

      it 'responds with unprocessable entity status' do
        make_request
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe '#update' do
    subject(:make_request) { put :update, params: params }

    let(:discount_params) { attributes_for(:discount) }
    let(:discount) { create(:complete_discount) }
    let(:params) { { id: discount.id, discount: discount_params } }

    include_context 'with admin user signed in'

    before do
      make_request
    end

    context 'when valid params are given' do
      it 'renders the view with http status found' do
        expect(response).to have_http_status(:found)
      end

      it 'redirects into show page' do
        expect(response).to redirect_to action: :show
      end
    end

    context 'when invalid params are given' do
      let(:discount_params) { attributes_for(:discount, ends_at: nil) }

      it 'responds with unprocessable entity status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'renders the edit template' do
        expect(response).to render_template(:edit)
      end
    end
  end
end
