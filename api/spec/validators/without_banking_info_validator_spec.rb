describe WithoutBankingInfoValidator do
  subject(:validator) { described_class.new(attributes: true) }

  describe '#validate' do
    let(:record) { create(:ticket_discount) }

    before do
      validator.validate(record)
    end

    context 'when a ticket is created by a user with banking info' do
      it 'doesn\'t add any error to the model' do
        expect(record.errors.any?).to be false
      end
    end

    context 'when a ticket is created by a user without banking info' do
      let(:record) { build(:ticket_discount, :without_banking_info) }

      it 'adds error in the model' do
        expect { record.save! }.to raise_error(
          ActiveRecord::RecordInvalid,
          I18n.t(:blank, scope: %i[without_banking_info])
        )
      end
    end
  end
end
