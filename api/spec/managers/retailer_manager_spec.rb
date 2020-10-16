describe RetailerManager do
  describe '#create' do
    subject(:manager) { described_class.new(params) }

    let(:params) { attributes_for(:retailer) }

    context 'when a proper retailer is created' do
      it 'persist the new retailer' do
        expect(manager.create.persisted?).to be true
      end

      it 'creates a new one' do
        expect { manager.create }.to change(Retailer, :count).from(0).to(1)
      end
    end

    context 'when the retailer already exists' do
      before do
        manager.create
      end

      it 'does not add a new retailer' do
        expect { manager.create }.not_to change(Retailer, :count)
      end
    end

    context 'when no params are given' do
      let(:params) { {} }

      it 'does not create the retailer' do
        expect { manager.create }.not_to change(Retailer, :count)
      end
    end
  end
end
