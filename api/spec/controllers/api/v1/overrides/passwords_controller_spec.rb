describe Api::V1::Overrides::PasswordsController, type: :controller do
  describe 'PUT #update' do
    subject(:req) do
      put :update, params: {
        user_id: user.id, user: { password: 'aA1234567833!', confirmed_password: 'aA1234567833!' }
      }
    end

    before do
      request.env['devise.mapping'] = Devise.mappings[:user]
    end

    let(:user) { create(:user) }
    let(:back_path) { edit_user_password_path(user_id: user.id) }

    context 'when password is correctly changed' do
      it 'displays success flash message' do
        req
        expect(flash[:success]).to(
          match(I18n.t('administrate.controller.update.success', resource: user.email))
        )
      end
      include_examples 'redirect back'
    end

    context 'when password change fails' do
      let(:user) { create(:user) }

      let(:req) do
        put :update, params: {
          user_id: user.id, user: { password: 'aA12', confirmed_password: 'aA12' }
        }
      end

      it 'displays alert flash message' do
        req
        expect(flash[:error]).to match(
          ['Contraseña es demasiado corto (6 caracteres mínimo)']
        )
      end
      include_examples 'redirect back'
    end
  end
end
