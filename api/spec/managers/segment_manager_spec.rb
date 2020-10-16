describe SegmentManager do
  describe '#create' do
    subject(:manager) { described_class.new(params) }

    let(:params) { attributes_for(:segment) }

    context 'when a proper segment is created' do
      it 'persist the new segment' do
        expect(manager.create.persisted?).to be true
      end

      it 'creates a new one' do
        expect { manager.create }.to change(Segment, :count).from(0).to(1)
      end
    end

    context 'when the segment already exists' do
      before do
        manager.create
      end

      it 'does not add a new segment' do
        expect { manager.create }.not_to change(Segment, :count)
      end
    end

    context 'when no params are given' do
      let(:params) { {} }

      it 'does not create the segment' do
        expect { manager.create }.not_to change(Segment, :count)
      end
    end
  end
end
