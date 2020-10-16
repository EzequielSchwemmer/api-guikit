describe FakeModels::RolePermissions do
  subject(:permissions) { described_class.new }

  let(:attribute_check) do
    Permission.codes.keys.all? { |code| permissions.respond_to?(code) }
  end

  it 'has all permissions as methods' do
    expect(attribute_check).to be true
  end

  include_examples 'fake models examples'
end
