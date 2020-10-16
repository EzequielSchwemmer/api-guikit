describe PermissionManager do
  subject(:manager) { described_class.new(params) }

  let(:role) { create(:role, :with_all_permissions) }

  describe '#permissions_for' do
    let(:params) { {} }
    let(:booleans) { [true, false] }

    let(:all_bolean?) do
      manager.permissions_for(role).values.all? { |permission| booleans.include?(permission) }
    end

    it 'returns a fake model with permissions' do
      expect(manager.permissions_for(role)).to be_a(FakeModels::RolePermissions)
    end
  end

  describe '#update_permissions!' do
    let(:params) { { show_discount: true } }

    it 'does not raise an error' do
      expect { manager.update_permissions!(role) }.not_to raise_error
    end

    it 'updates the permissions of the role' do
      manager.update_permissions!(role)
      expect(role.reload.permissions.size).to eq(params.size)
    end
  end
end
