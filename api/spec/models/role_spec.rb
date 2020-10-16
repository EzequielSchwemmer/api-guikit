describe Role do
  subject(:role) { create(:role) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  context 'when a role does not have a name' do
    subject(:role) { build(:role, name: nil) }

    it { is_expected.not_to be_valid }
  end

  describe '#allows?' do
    let(:code) { Permission.codes.keys.sample }
    let(:add_permission) do
      role.permissions << Permission.find_or_create_by!(code: code)
    end

    it 'allows the action when added' do
      add_permission
      expect(role.allows?(code)).to be true
    end

    it 'does not allow the action when not added' do
      expect(role.allows?(code)).to be false
    end
  end

  describe '#allows_any?' do
    let(:codes) do
      Permission.codes.keys.map(&:to_sym).select.with_index { |_, index| (index % 3).zero? }
    end
    let(:non_selected_codes) do
      Permission.codes.keys.select.with_index do |_, index|
        (index % 2).zero? && (index % 3).nonzero?
      end
    end
    let(:add_permissions) do
      role.permissions << codes.map { |code| Permission.find_or_create_by!(code: code) }
    end

    let(:code) { codes.sample }
    let(:non_selected_code) { non_selected_codes.sample }

    it 'allows the action when the code was added' do
      add_permissions
      expect(role.allows_any?(code)).to be true
    end

    it 'allows the action when only an added permission is checked' do
      add_permissions
      expect(role.allows_any?(non_selected_code, code)).to be true
    end

    it 'does not allow actions when not added' do
      expect(role.allows_any?(*non_selected_codes)).to be false
    end
  end

  describe '#allows_all?' do
    let(:codes) do
      Permission.codes.keys.map(&:to_sym).select.with_index { |_, index| (index % 3).zero? }
    end
    let(:non_selected_codes) do
      Permission.codes.keys.map(&:to_sym).select.with_index do |_, index|
        (index % 2).zero? && (index % 3).nonzero?
      end
    end
    let(:add_permissions) do
      role.permissions << codes.map { |code| Permission.find_or_create_by!(code: code) }
    end

    let(:code) { codes.sample }
    let(:non_selected_code) { non_selected_codes.sample }

    it 'allows the action when the code was added' do
      add_permissions
      expect(role.allows_all?(code)).to be true
    end

    it 'does not allow the action when a code is not present' do
      add_permissions
      expect(role.allows_all?(non_selected_code, code)).to be false
    end
  end
end
