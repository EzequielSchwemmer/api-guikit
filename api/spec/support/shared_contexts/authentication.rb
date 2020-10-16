shared_context 'with customer signed in' do
  let(:current_user) { create(:user) }

  before do
    request.headers.merge! current_user.create_new_auth_token
  end
end

shared_context 'with admin user signed in' do
  let(:current_user) { create(:admin_user) }

  before do
    sign_in current_user
  end
end
