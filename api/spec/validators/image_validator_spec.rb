describe ImageValidator do
  subject(:validator) { described_class.new(attributes: true) }

  describe '#validate_each' do
    context 'when a non-image file is tried to be uploaded' do
      let(:record) { build(:ticket, :with_user, :with_pictures) }

      it 'doesn\'t add any error to the model' do
        expect(record.errors.any?).to be false
      end
    end

    context 'when a image is tried to be uploaded' do
      let!(:record) { build(:ticket, :with_non_image_file, user: user) }
      let!(:user) { create(:user) }

      it 'adds error in the model' do
        create(:banking_info, user: user)
        expect { record.save! }.to raise_error(
          ActiveRecord::RecordInvalid,
          I18n.t(:wrong_format, scope: %i[pictures])
        )
      end
    end
  end
end
