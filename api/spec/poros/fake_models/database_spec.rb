describe FakeModels::Database do
  subject(:database) { described_class.new(options: options) }

  let(:options) do
    FakeModels::DatabaseOptions.new(
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

  it 'has valid options' do
    expect(database.options).to be_valid
  end

  context 'when options are missing a parameter' do
    let(:offset) { -1 }

    it { is_expected.not_to be_valid }

    it 'has invalid options' do
      expect(database.options).not_to be_valid
    end
  end

  include_examples 'fake models examples'
end
