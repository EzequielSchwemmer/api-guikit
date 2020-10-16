describe Database::XlsGenerator do
  subject(:generator) { described_class.new }

  let(:finder) { ModelFinder.new }

  describe '#export' do
    let(:selection) { generator.all_selected }
    let(:sheet) { generator.export(selection) }

    context 'when all models are selected' do
      it 'generates an axlsx package' do
        expect(sheet).to be_kind_of(Axlsx::Package)
      end

      it 'creates as many sheets as selected models' do
        expect(sheet.workbook.worksheets.size).to eq(selection.size)
      end
    end

    context 'when a simple model is selected' do
      let(:selection) { { finder.model_keys.sample => true } }

      it 'creates as many sheets as selected models' do
        expect(sheet.workbook.worksheets.size).to eq(selection.size)
      end
    end
  end

  describe '#all_selected' do
    it 'has the same amount of elements as the finder' do
      expect(generator.all_selected.size).to eq(finder.model_keys.size)
    end
  end
end
