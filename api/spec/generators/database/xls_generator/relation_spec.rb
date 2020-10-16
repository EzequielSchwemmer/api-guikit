describe Database::XlsGenerator::Relation do
  describe '#resolve' do
    subject(:relation) { described_class.new(model, options) }

    let(:element_count) { 10 }
    # Almost all factories work on the get-go, some require trais. This test should be agnostic
    let(:factory) { %i[retailer product admin_user user].sample }
    let(:model) { factory.to_s.camelize.classify.constantize }
    let(:create_models) { create_list(factory, element_count) }

    before do
      create_models
    end

    context 'when no options are given' do
      let(:options) { {} }

      it 'returns all elements on the collection' do
        expect(relation.resolve.count).to eq(model.count)
      end
    end

    context 'when since is present' do
      let(:create_models) { create_list(factory, element_count, created_at: 4.days.ago) }
      let(:options) { { since: 2.days.ago } }

      before do
        create(factory, created_at: 1.day.ago)
      end

      it 'does not return all elements' do
        expect(relation.resolve.count).not_to eq(model.count)
      end
    end

    context 'when upto is present' do
      let(:create_models) { create_list(factory, element_count, created_at: 4.days.ago) }
      let(:options) { { upto: 2.days.ago } }

      before do
        create(factory, created_at: 1.day.ago)
      end

      it 'does not return all elements' do
        expect(relation.resolve.count).not_to eq(model.count)
      end
    end

    context 'when a limit is present' do
      let(:limit) { Faker::Number.between(1, element_count - 1) }
      let(:options) { { limit: limit } }

      it 'does not return all elements' do
        expect(relation.resolve.count).not_to eq(model.count)
      end

      it 'returns at most the limit' do
        expect(relation.resolve.count).to be <= limit
      end
    end

    context 'when an offset is present' do
      let(:offset) { Faker::Number.between(1, element_count - 1) }
      let(:options) { { offset: offset } }

      before do
        create(factory, created_at: 2.days.ago)
      end

      it 'does not return all elements' do
        expect(relation.resolve.count).not_to eq(model.count)
      end
    end
  end
end
