describe SetInitialDiscounts do
  subject(:context) do
    described_class.call user: current_user
  end

  describe '.call' do
    context 'when a initial segment exists and has discounts' do
      let(:current_user) { create(:user) }
      let(:segment) { create(:segment, name: 'initial') }
      let(:discount) { create(:discount, :with_picture) }
      let(:discount_segment) { create(:discount_segment, discount: discount, segment: segment) }

      it 'creates UserSegment' do
        expect { context }.to change(UserSegment, :count).by(1)
      end

      it 'creates UserDiscount' do
        discount_segment
        expect { context }.to change(UserDiscount, :count).by(1)
      end
    end
  end
end
