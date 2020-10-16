describe DatabaseManager do
  subject(:manager) { described_class.new(params, options) }

  let(:options) { nil }

  describe '#build' do
    let(:params) { {} }

    context 'when empty params are given' do
      it 'does not rise an error' do
        expect { manager.build }.not_to raise_error
      end

      it 'builds a database model' do
        expect(manager.build).to be_a(FakeModels::Database)
      end
    end

    context 'when valid options are given' do
      let(:options) { { since: 2.days.ago } }

      it 'builds a database model' do
        expect(manager.build).to be_a(FakeModels::Database)
      end

      it 'builds a valid object' do
        expect(manager.build).to be_valid
      end
    end

    context 'when options are invalid' do
      let(:options) { { since: 2.days.ago, upto: 4.days.ago } }

      it 'builds a database model' do
        expect(manager.build).to be_a(FakeModels::Database)
      end

      it 'builds an invalid model' do
        expect(manager.build).not_to be_valid
      end
    end

    context 'when parameters are given' do
      let(:params) { { user: true, role: false } }
      let(:model) { manager.build }

      it 'builds a database model' do
        expect(model).to be_a(FakeModels::Database)
      end

      it 'Makes the object with the attributes as parameters given' do
        expect(model.user).to be_a(TrueClass)
        expect(model.role).to be_a(FalseClass)
      end
    end
  end
end
