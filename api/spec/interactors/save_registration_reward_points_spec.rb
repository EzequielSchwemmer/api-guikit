describe SaveRegistrationRewardPoints do
  subject(:context) do
    described_class.call user: current_user
  end

  describe '.call' do
    context 'when banking information correctly created' do
      let(:current_user) { create(:user) }

      it 'succeeds' do
        expect(context).to be_a_success
      end

      it 'provides reward points' do
        expect(context.points).to eq(Reward.last.points)
      end

      it 'creates reward' do
        expect { context }.to change(Reward, :count).by(1)
      end
    end
  end
end
