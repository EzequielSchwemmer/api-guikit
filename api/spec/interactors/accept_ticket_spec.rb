describe AcceptTicket do
  subject(:interactor) { described_class }

  let(:current_user) { create(:admin_user) }
  let(:reward) do
    Faker::Number.between(1, Rails.application.secrets.boost_points_limit).to_f.floor
  end
  let(:ticket) { create(:ticket, :with_pictures, :with_user) }

  let(:interactor_context) do
    interactor.call(
      ticket: ticket,
      current_user: current_user,
      reward: reward,
      reason_message: 'Correct Ticket',
      emitted_at: Faker::Date.between(2.weeks.ago, 1.day.ago).to_datetime,
      ticket_code: Faker::Code.imei
    )
  end

  context 'when a ticket is accepted' do
    it 'succeeds' do
      expect(interactor_context).to be_a_success
    end

    it 'sets the ticket to reviewed' do
      interactor_context
      expect(ticket.reload.status).to eq 'reviewed'
    end

    it 'creates a reward' do
      expect { interactor_context }.to change(Reward, :count).by(1)
    end
  end

  context 'when no rewards are given' do
    let(:reward) { nil }

    it 'fails' do
      expect(interactor_context.success?).to be false
    end

    it 'does not set the ticket to reviewed' do
      interactor_context
      expect(ticket.reload.status).not_to eq 'reviewed'
    end

    it 'does not create a reward' do
      expect { interactor_context }.not_to change(Reward, :count)
    end
  end

  context 'when no user is given' do
    let(:current_user) { nil }

    it 'fails' do
      expect(interactor_context.success?).to be false
    end

    it 'does not set the ticket to reviewed' do
      interactor_context
      expect(ticket.reload.status).not_to eq 'reviewed'
    end

    it 'does not create a reward' do
      expect { interactor_context }.not_to change(Reward, :count)
    end
  end
end
