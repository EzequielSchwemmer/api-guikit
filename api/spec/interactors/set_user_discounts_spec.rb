describe SetUserDiscounts do
  subject(:context) do
    described_class.call(user: current_user)
  end

  let(:current_user) { create(:user) }
  let(:segment) { build_stubbed(:segment) }
  let(:discount_segment) { build_stubbed(:discount_segment, segment: segment) }
  let(:user_segment) { build_stubbed(:user_segment, segment: segment, user: current_user) }
  let(:user_discount) { create(:user_discount) }

  describe '.call' do
    context 'when user discounts are correctly created' do
      let(:current_user) { create(:user) }
      let(:segment) { create(:segment) }
      let(:discount_segment) { create(:discount_segment, segment: segment) }
      let(:user_segment) { create(:user_segment, segment: segment, user: current_user) }

      it 'creates new UsersDiscount' do
        user_segment
        discount_segment
        expect { context }.to change(UserDiscount, :count).by(1)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end
    end

    context 'when user discounts are correctly deleted' do
      it 'deletes UserDiscounts that do not satisfy the segment rule' do
        current_user.user_discounts << user_discount
        current_user.save!
        expect { context }.to change(UserDiscount, :count).by(-1)
      end

      it 'succeeds' do
        expect(context).to be_a_success
      end
    end
  end
end
