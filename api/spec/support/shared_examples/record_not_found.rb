shared_examples 'record not found' do
  include_context 'with customer signed in'

  it 'responds with 404' do
    req
    expect(response).to have_http_status(:not_found)
  end
end
