shared_examples 'redirect back' do
  it 'redirects back' do
    req
    expect(response).to redirect_to(back_path)
  end
end
