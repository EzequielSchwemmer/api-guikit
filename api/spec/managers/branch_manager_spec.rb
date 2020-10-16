describe BranchManager do
  describe '#create' do
    let(:retailer) { create(:retailer) }
    let(:params) { attributes_for(:branch) }
    let(:manager) { described_class.new(retailer, params) }

    context 'when a proper branch is created' do
      it 'persist the new branch' do
        expect(manager.create.persisted?).to be true
      end

      it 'creates a new one' do
        expect { manager.create }.to change(Branch, :count).from(0).to(1)
      end
    end

    context 'when the branch already exists' do
      before do
        manager.create
      end

      it 'does not add a new branch' do
        expect { manager.create }.not_to change(Branch, :count)
      end
    end

    context 'when no params are given' do
      let(:params) { {} }

      it 'does not create the branch' do
        expect { manager.create }.not_to change(Branch, :count)
      end
    end
  end
end
