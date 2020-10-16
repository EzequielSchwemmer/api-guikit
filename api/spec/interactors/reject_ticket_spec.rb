describe RejectTicket do
  subject(:interactor) { described_class }

  let(:current_user) { create(:admin_user) }
  let(:penalty) do
    Faker::Number.between(1, Rails.application.secrets.boost_points_limit).to_f.floor
  end
  let(:ticket) { create(:ticket, :with_pictures, :with_user) }
  let(:reason) { Ticket::REJECTED_STATUSES.sample }

  let(:interactor_context) do
    interactor.call(
      reason: reason,
      ticket: ticket,
      current_user: current_user,
      penalty: penalty
    )
  end

  context 'when a ticket is rejected' do
    it 'succeeds' do
      expect(interactor_context.success?).to be true
    end

    it 'sets the ticket to the rejection status' do
      interactor_context
      expect(ticket.reload.status).to eq reason.to_s
    end

    it 'creates a penalty (as a reward)' do
      expect { interactor_context }.to change(Reward, :count).by(1)
    end
  end

  context 'when no penalty is given' do
    let(:penalty) { nil }

    it 'fails' do
      expect(interactor_context.success?).to be false
    end

    it 'does not the ticket to the rejection status' do
      interactor_context
      expect(ticket.reload.status).not_to eq reason.to_s
    end

    it 'does not create a penalty (as a reward)' do
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

    it 'does not create a penalty (as a reward)' do
      expect { interactor_context }.not_to change(Reward, :count)
    end
  end

  context 'when the reason is not a reject reason' do
    let(:reason) { :reviewed }

    it 'fails' do
      expect(interactor_context.success?).to be false
    end

    it 'does not the ticket to reviewed' do
      interactor_context
      expect(ticket.reload.status).not_to eq 'reviewed'
    end

    it 'does not create a penalty (as a reward)' do
      expect { interactor_context }.not_to change(Reward, :count)
    end
  end
end
