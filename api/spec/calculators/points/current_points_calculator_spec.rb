describe Points::CurrentPointsCalculator do
  subject(:user) { create(:user, :with_banking_info) }

  let(:user_discount) { create(:user_discount, user: user) }
  let(:ticket_discount) { create(:ticket_discount, ticket: ticket, discount: discount) }
  let(:reward) { create(:reward, user: user) }
  let(:ticket) { create(:ticket, :with_pictures, user: user) }
  let(:discount) { create(:discount, :with_picture) }

  let(:expected) do
    {
      data: {
        user_id: user.id,
        attributes: {
          current_points: described_class.current_points(user),
          total_gained_points: described_class.gained_points(user),
          total_spent_points: described_class.spent_points(user),
          lost_points: described_class.lossings(user),
          gained_points: described_class.winnings(user),
          deficit: described_class.point_deficit(user)
        }
      }
    }
  end

  before do
    discount
    ticket
    reward
    ticket_discount
    user_discount
  end

  describe '.gained_points' do
    context 'when requesting gained points' do
      it 'provides correct number of gained points' do
        gained = described_class.gained_points(user)
        expect(gained).to eq(user.rewards.pluck(:points).sum)
      end
    end
  end

  describe '.spent_points' do
    context 'when requesting spent points' do
      it 'provides correct number of spent points' do
        spent = described_class.spent_points(user)
        expect(spent).to eq(user.ticket_discounts.includes(:discount).pluck(:cost).sum)
      end
    end
  end

  describe '.current_points' do
    context 'when requesting current points' do
      it 'provides correct number of spent points' do
        current = described_class.current_points(user)
        spent = user.ticket_discounts.includes(:discount).pluck(:cost).sum
        gained = user.rewards.pluck(:points).sum
        expected = [0, gained - spent].max
        expect(current).to eq(expected)
      end
    end
  end

  describe '.call' do
    context 'when requesting points hash' do
      it 'provides correct hash' do
        expect(described_class.call(user)).to eq(expected.to_json)
      end
    end
  end
end
