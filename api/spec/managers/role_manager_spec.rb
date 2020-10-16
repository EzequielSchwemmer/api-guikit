describe RoleManager do
  subject(:manager) { described_class.new(params) }

  describe '#build' do
    let(:params) { { name: Faker::Name.name } }

    it 'builds a role' do
      expect(manager.build).to be_a(Role)
    end

    it 'builds a valid role' do
      expect(manager.build).to be_valid
    end
  end

  describe '#save' do
    let(:params) { { name: Faker::Name.name, permissions: { code => true } } }
    let(:code) { Permission.codes.keys.sample }
    let(:role) { create(:role) }

    it 'updates a role' do
      expect(manager.save(role)).to be true
    end

    it 'updates the name' do
      manager.save(role)
      expect(role.reload.name).to eq(params[:name])
    end

    it 'updates the permissions' do
      manager.save(role)
      expect(role.reload.permissions.count).to eq(params[:permissions].size)
    end

    it 'makes the role allowed to perform the action' do
      manager.save(role)
      expect(role.reload.allows?(code)).to be true
    end
  end
end
