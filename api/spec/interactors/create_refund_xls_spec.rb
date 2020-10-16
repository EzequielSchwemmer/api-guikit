describe CreateRefundXls do
  describe '.call' do
    let(:context) { described_class.call(params: params, generator: generator) }
    let(:generator) { Payments::XlsGenerator.new }
    let(:params) { { payments: { '0' => payment } } }
    let(:payment) { { export: '1', user_id: user.id } }
    let(:user) { create(:user) }
    let(:build_tickets) { create_list(:ticket, 5, :approved, user: user) }

    before do
      build_tickets
    end

    context 'when valid params are used' do
      it 'is a success' do
        expect(context).to be_a_success
      end

      it 'creates a package' do
        expect(context.package).to be_kind_of(Axlsx::Package)
      end
    end

    context 'when invalid parameters are used' do
      let(:params) { {} }

      it 'fails' do
        expect(context).not_to be_a_success
      end
    end
  end
end
