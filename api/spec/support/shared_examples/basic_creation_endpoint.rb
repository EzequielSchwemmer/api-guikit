shared_examples 'basic creation endpoint' do
  before do
    request.headers.merge! user.create_new_auth_token
  end

  it 'creates the model' do
    expect { req }.to change(model_klass, :count).by(1)
  end

  it 'returns status code created' do
    req
    expect(response).to have_http_status(:created)
  end
end
