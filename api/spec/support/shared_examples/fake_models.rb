shared_examples 'fake models examples' do
  it 'has a model name' do
    expect(described_class.model_name).to be_present
  end
end
