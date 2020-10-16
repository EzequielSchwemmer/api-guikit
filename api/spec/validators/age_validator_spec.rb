describe AgeValidator do
  subject(:validator) { described_class.new(attributes: true) }

  describe '#validate_each' do
    let(:birthday) { 16.years.ago }
    let(:record) { build_stubbed(:user, birthday: birthday) }

    before do
      validator.validate_each(record, :birthday, birthday)
    end

    context 'when a valid birthday is provided' do
      it 'doesn\'t add any error to the model' do
        expect(record.errors.any?).to be false
      end
    end

    context 'when an invalid birthday is provided' do
      let(:birthday) { 15.years.ago }

      it 'adds error in the model' do
        expect(record.errors.any?).to be true
      end
    end
  end
end
