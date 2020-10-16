shared_examples 'common admin authentication examples' do
  context 'without an admin signed in the administration' do
    it 'redirects to login url' do
      expect(make_request).to redirect_to action: :create,
                                          controller: 'devise/sessions'
    end
  end
end
