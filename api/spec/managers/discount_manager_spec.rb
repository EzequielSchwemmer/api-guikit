describe DiscountManager do
  subject(:manager) { described_class.new(current_user, params) }

  let(:params) do
    attributes_for(:discount)
      .merge(
        picture: fixture_file_upload('spec/support/fixtures/test_image.png')
      )
  end
  let(:current_user) { build_stubbed(:admin_user) }

  describe '#create' do
    let(:new_discount) { manager.create }

    context 'when valid parmaters are given' do
      it 'creates a valid discount' do
        expect(new_discount).to be_valid
      end

      it 'persist the new discount' do
        expect(new_discount.persisted?).to be true
      end
    end
  end

  describe '#update' do
    let(:discount) { create(:discount, :with_picture, :with_steps) }

    context 'when valid parameters are given' do
      it 'propertly updates the discount' do
        expect(manager.update(discount)).to be true
      end

      it 'has a valid discount' do
        manager.update(discount)
        expect(discount).to be_valid
      end
    end

    context 'when invalid parameters are given' do
      let(:params) { attributes_for(:discount, terms_and_conditions: nil) }

      it 'does not update the discount' do
        expect(manager.update(discount)).to be false
      end

      it 'has an invalid discount' do
        manager.update(discount)
        expect(discount).not_to be_valid
      end
    end
  end
end
