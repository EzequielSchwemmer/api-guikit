describe FakeModels::Base do
  subject(:model) { described_class.new }

  it 'is not persisted' do
    expect(model.persisted?).to be false
  end

  include_examples 'fake models examples'
end
