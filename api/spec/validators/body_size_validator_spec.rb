describe BodySizeValidator do
  subject(:validator) { described_class.new(attributes: true) }

  describe '#validate_each' do
    context 'when a picture with permited size is trying to be uploaded' do
      let(:record) { build(:ticket, :with_user, :with_pictures) }

      it 'doesn\'t add any error to the model' do
        expect(record.errors.any?).to be false
      end
    end

    context 'when a picture with unpermited size is trying to be uploaded' do
      let!(:record) { build(:ticket, :with_heavy_picture, user: user) }
      let!(:user) { create(:user) }

      it 'adds error in the model' do
        create(:banking_info, user: user)
        expect { record.save! }.to raise_error(
          ActiveRecord::RecordInvalid,
          I18n.t(:wrong_size, scope: %i[pictures])
        )
      end
    end
  end
end
