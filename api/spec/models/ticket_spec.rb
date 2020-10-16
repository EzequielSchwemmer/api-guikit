describe Ticket do
  subject(:ticket) { create(:ticket, :with_user, :with_pictures) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to have_many(:ticket_lines) }

  context 'when fraud is attempted' do
    subject(:ticket) { create(:ticket, :with_quick_review) }

    let(:copied_values) do
      ticket.attributes.slice('ticket_code', 'emitted_at', 'retailer_id', 'branch_id', 'status')
    end
    let(:fraudulent_ticket) { build(:ticket, copied_values) }

    it 'disallows the creation of a ticket with the same values' do
      expect(fraudulent_ticket).not_to be_valid
    end

    it 'has errors with the ticket code' do
      fraudulent_ticket.save
      expect(fraudulent_ticket.errors[:ticket_code].size).to be(1)
    end
  end

  context 'when a ticket is created without user' do
    subject(:ticket) { build(:ticket, :with_pictures) }

    it { is_expected.to be_invalid }
  end

  context 'when a ticket is created without pictures' do
    subject(:ticket) { build(:ticket, :with_user) }

    it { is_expected.to be_invalid }
  end

  context 'when a ticket is digitalized' do
    subject(:ticket) { build(:ticket, status: ticket_status) }

    let(:ticket_status) { Ticket::DIGITALIZED_STATUSES.sample }

    it 'makes the ticket digitalized' do
      expect(ticket.validate_digitalization?).to be true
    end
  end

  context 'when an user has chosen the segments of the ticket but no date is present' do
    subject(:ticket) { build(:digitalized_ticket, segments_chooser: random_admin) }

    let(:random_admin) { create(:admin_user) }

    it 'is invalid' do
      expect(ticket).not_to be_valid
    end
  end

  context 'when an user has chosen the segments of the ticket but only the date is present' do
    subject(:ticket) do
      build(:digitalized_ticket, segments_chosen_at: Faker::Date.between(1.year.ago, 1.day.ago))
    end

    it 'is invalid' do
      expect(ticket).not_to be_valid
    end
  end

  describe '#rejected?' do
    subject(:ticket) { build_stubbed(:ticket, status: ticket_status) }

    let(:ticket_status) { Ticket::REJECTED_STATUSES.sample }

    it 'is rejected' do
      expect(ticket.rejected?).to be true
    end

    context 'when a ticket is not rejected' do
      let(:ticket_status) { Ticket::DIGITALIZED_STATUSES.sample }

      it 'is not rejected' do
        expect(ticket.rejected?).to be false
      end
    end
  end

  describe '#validate_digitalization?' do
    subject(:ticket) { build_stubbed(:ticket, status: ticket_status) }

    let(:ticket_status) { Ticket::DIGITALIZED_STATUSES.sample }

    it 'is digitalized' do
      expect(ticket.validate_digitalization?).to be true
    end

    context 'when a ticket is not digitalized' do
      let(:ticket_status) { Ticket::REJECTED_STATUSES.sample }

      it 'is not digitalized' do
        expect(ticket.validate_digitalization?).to be false
      end
    end
  end

  describe '#general_status' do
    subject(:ticket) { build_stubbed(:ticket, status: ticket_status) }

    context 'when a ticket is approved' do
      let(:ticket_status) { %w[approved paid].sample }

      it 'returns accepted status' do
        expect(ticket.general_status).to eq 'ACCEPTED'
      end
    end

    context 'when a ticket is rejected' do
      let(:ticket_status) { Ticket::REJECTED_STATUSES.sample }

      it 'returns rejected status' do
        expect(ticket.general_status).to eq 'REJECTED'
      end
    end

    context 'when a ticket is in process' do
      let(:ticket_status) { %w[uploaded reviewed digitalized].sample }

      it 'returns in procss status' do
        expect(ticket.general_status).to eq 'IN_PROCESS'
      end
    end
  end
end
