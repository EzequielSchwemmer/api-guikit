describe FakeModels::DatabaseOptions do
  subject(:options) do
    described_class.new(
      since: since,
      upto: upto,
      limit: limit,
      offset: offset,
      spacing_rows: spacing,
      spacing_columns: spacing
    )
  end

  let(:since) { Faker::Date.between(1.month.ago, 2.months.ago) }
  let(:upto) { Faker::Date.between(since, 1.day.ago) }
  let(:limit) { Faker::Number.positive.to_i.floor }
  let(:offset) { 0 }
  let(:spacing) { Faker::Number.positive.to_i.floor }

  it { is_expected.to be_valid }

  context 'when offset is invalid' do
    let(:offset) { -1 }

    it { is_expected.not_to be_valid }
  end

  context 'when limit is invalid' do
    let(:limit) { 0 }

    it { is_expected.not_to be_valid }
  end

  context 'when since is bigger than upto' do
    let(:upto) { since - 1.day }

    it { is_expected.not_to be_valid }
  end

  include_examples 'fake models examples'
end
