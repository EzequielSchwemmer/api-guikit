describe ModelFinder do
  subject(:finder) { described_class.new }

  describe '#application_models' do
    let(:direct_descendants) do
      ApplicationRecord.descendants.filter do |model|
        # Only get descendants of ApplicationRecord
        model.superclass == ApplicationRecord && !model.abstract_class
      end
    end

    # This class is really specific and I don't really know a better test for this case
    it 'returns all direct descendants of ApplicationRecord' do
      expect(finder.application_models).to match_array(direct_descendants)
    end

    it 'every element has ApplicationRecord as supperclass' do
      condition = finder.application_models.all? { |klass| klass.superclass == ApplicationRecord }
      expect(condition).to be true
    end
  end

  describe '#model_keys' do
    it 'returns the same amount of keys as existing models' do
      expect(finder.model_keys.size).to eq(finder.application_models.count)
    end
  end

  describe '#select_models' do
    let(:model_keys) { finder.model_keys }
    let(:selected) { { model_keys.sample => true } }

    it 'returns only the selected model count' do
      expect(finder.select_models(selected).count).to eq(selected.keys.count)
    end
  end
end
