describe SaveBoostRewardPoints do
  subject(:context) do
    described_class.call user: ticket.user, ticket: ticket, points: points
  end

  let(:ticket) { create(:ticket, :with_pictures, :with_user) }
  let(:points_limit) { Rails.application.secrets.boost_points_limit }

  describe '.call' do
    context 'when a ticket is correctly boosted' do
      let(:points) { Faker::Number.between(1, points_limit).to_f.floor }
      let(:ticket) { create(:ticket, :with_pictures, :with_user) }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'creates reward' do
        expect { context }.to change(Reward, :count).by(1)
      end
    end

    context 'when a ticket is correctly penalized' do
      let(:points) { Faker::Number.between(1, points_limit).to_f.floor }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'creates reward' do
        expect { context }.to change(Reward, :count).by(1)
      end
    end

    context 'when a penalization is greater than current points' do
      let(:points) { -100 }

      it 'chantes the penalization value to current points' do
        context
        expect(Reward.last.points).to eq(
          Points::CurrentPointsCalculator.current_points(ticket.user) * -1
        )
      end
    end

    context 'when a penalization is lesser than current points' do
      let(:reward) { create(:reward, user: ticket.user) }
      let(:penalization_reward) { create(:reward, user: ticket.user, points: points) }
      let(:points) { -1 }

      it 'does not chante the penalization value' do
        context
        reward
        penalization_reward
        expect(penalization_reward.points).to eq(points)
      end
    end

    context 'when a boost is positive' do
      let(:reward) { create(:reward, user: ticket.user, points: points) }
      let(:points) { 10 }

      it 'does not change the boost value' do
        context
        reward
        expect(reward.points).to eq(points)
      end
    end

    context 'when points are zero' do
      let(:points) { 0 }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'does not create reward' do
        expect { context }.not_to change(Reward, :count)
      end
    end
  end
end
