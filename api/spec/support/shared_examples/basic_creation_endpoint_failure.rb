shared_examples 'basic creation failure endpoint' do
  before do
    request.headers.merge! user.create_new_auth_token
  end

  it 'returns error messages' do
    req
    resp = ActiveSupport::JSON.decode(response.body)
    expect(resp['data']['errors']).to be_present
  end

  it 'fails to create a new model' do
    expect { req }.to change(model_klass, :count).by(0)
  end

  it 'returns status code precondition failed' do
    req
    expect(response).to have_http_status(:precondition_failed)
  end
end
