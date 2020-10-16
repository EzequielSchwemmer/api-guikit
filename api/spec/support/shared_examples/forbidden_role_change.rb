shared_examples 'forbidden role change' do
  it 'fails to change role' do
    expect { req }.not_to(change { user.roles.first.name })
  end

  it 'responds with forbidden status' do
    req
    expect(response).to have_http_status(:forbidden)
  end
end
