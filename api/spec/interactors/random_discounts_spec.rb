describe RandomDiscounts do
  subject(:context) do
    described_class.call
  end

  describe '.call' do
    context 'when requesting random discounts' do
      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides 12 discounts' do
        create_list(:discount, 13, :with_picture, :with_steps, featured: true, active: true)
        expect(context.discounts.length).to eq(12)
      end
    end
  end
end
