describe TicketManager do
  subject(:manager) { described_class.new(current_user, ticket_params) }

  let(:current_user) { create(:user) }
  let(:banking_info) { create(:banking_info, user: current_user) }

  let(:ticket_params) do
    ActionController::Parameters.new(pictures: pictures).permit(pictures: [])
  end
  let(:pictures) { [fixture_file_upload('spec/support/fixtures/test_image.png')] }
  let(:points_limit) { Rails.application.secrets.boost_points_limit }

  describe '#build' do
    it 'builds a valid ticket' do
      banking_info
      expect(manager.build).to be_valid
    end

    context 'when no params are given to the manager' do
      let(:ticket_params) { nil }

      it 'builds an invalid ticket' do
        expect(manager.build).not_to be_valid
      end
    end

    context 'when no user is given to the manager' do
      let(:current_user) { nil }

      it 'raises an error' do
        expect { manager.build }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#create!' do
    it 'creates a valid ticket' do
      banking_info
      expect(manager.create!).to be_valid
    end

    context 'when no params are given to the manager' do
      let(:ticket_params) { nil }

      it 'raises an error' do
        expect { manager.create! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when no user is given to the manager' do
      let(:current_user) { nil }

      it 'raises an error' do
        expect { manager.create! }.to raise_error(NoMethodError)
      end
    end
  end

  describe '#digitalize' do
    let(:ticket) { create(:reviewed_ticket) }
    let(:ticket_discount) { create(:ticket_discount, ticket: ticket) }
    let(:current_user) { create(:admin_user) }
    let(:ticket_line_params) do
      attributes_for(:ticket_line).merge(product: attributes_for(:product))
    end
    let(:line_params) { { ticket_line_attributes: [ticket_line_params] } }
    let(:ticket_params) do
      attributes_for(:ticket, :digitalized)
        .merge(line_params)
        .merge(retailer_attributes: attributes_for(:retailer))
        .merge(branch_attributes: attributes_for(:branch))
        .merge(digitalizer: current_user, digitalized_at: Time.zone.now)
    end

    context 'when correct parameters are given' do
      before do
        ticket_discount
        manager.digitalize(ticket)
      end

      it 'makes the ticket valid' do
        expect(ticket.valid?).to be true
      end

      it 'digitalizes the ticket' do
        expect(ticket.digitalized?).to be true
      end
    end

    context 'when invalid parameters are given' do
      let(:ticket_params) { attributes_for(:ticket, :digitalized) }

      before do
        manager.digitalize(ticket)
      end

      it 'makes the ticket invalid' do
        expect(ticket.valid?).to be false
      end
    end
  end

  describe '#accept' do
    let(:ticket) { create(:ticket, :with_pictures, :with_user) }
    let(:current_user) { create(:admin_user) }
    let(:points) { Faker::Number.between(1, points_limit).to_f.floor }
    let(:ticket_params) do
      {
        reward: { points: points },
        emitted_at: Faker::Date.between(2.weeks.ago, 1.day.ago).to_datetime,
        ticket_code: Faker::Code.imei
      }
    end

    context 'when the ticket is accepted' do
      before do
        manager.accept(ticket)
      end

      it 'makes the ticket rejected' do
        expect(ticket.reload.reviewed?).to be true
      end

      it 'sets the ticket reviewer to reviewer admin' do
        expect(ticket.reload.quick_reviewer).to eq(current_user)
      end
    end
  end

  describe '#reject' do
    let(:ticket) { create(:ticket, :with_pictures, :with_user) }
    let(:current_user) { create(:admin_user) }
    let(:status) { Ticket::REJECTED_STATUSES.sample }
    let(:points) { Faker::Number.between(1, points_limit).to_f.floor }
    let(:ticket_params) { { status: status, reward: { points: points } } }

    context 'when penalize success' do
      before do
        manager.reject(ticket)
      end

      it 'makes the ticket rejected' do
        expect(ticket.reload.rejected?).to be true
      end

      it 'sets the ticket reviewer to reviewer admin' do
        expect(ticket.reload.quick_reviewer).to eq(current_user)
      end
    end
  end
end
