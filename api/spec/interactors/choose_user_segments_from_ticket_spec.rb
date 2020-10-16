describe ChooseUserSegmentsFromTicket do
  subject(:interactor) { described_class }

  let(:params) { { segment_ids: segment_ids } }
  let(:current_user) { create(:admin_user) }
  let(:ticket) { create(:digitalized_ticket) }
  let(:segments) { create_list(:segment, 5) }
  let(:segment_ids) { segments.pluck(:id) }

  let(:interactor_context) do
    interactor.call(
      params: params,
      current_user: current_user,
      ticket: ticket
    )
  end

  describe '.call' do
    context 'when valid parameters are used' do
      it 'succeeds' do
        expect(interactor_context.success?).to be true
      end

      it 'updates the segments of the user' do
        interactor_context
        expect(ticket.user.reload.segments).to match_array(segments)
      end
    end

    context 'when invalid parameters are used' do
      let(:params) { nil }

      it 'fails' do
        expect(interactor_context.success?).to be false
      end
    end
  end
end
