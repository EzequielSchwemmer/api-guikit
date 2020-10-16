describe Api::V1::TicketsController, type: :controller do
  describe 'POST #create' do
    subject(:req) do
      post :create, params: {
        ticket: {
          pictures: pictures,
          discounts: { ids: discounts.pluck(:id) }
        }
      }
    end

    let(:discounts) { create_list(:complete_discount, 1) }
    let(:user_discounts) { create(:user_discount, discount: discounts.first, user: user) }
    let(:pictures) { [fixture_file_upload('spec/support/fixtures/test_image.png')] }
    let(:user) { create(:user, :with_banking_info) }
    let(:model_klass) { Ticket }

    context 'when creating a valid ticket' do
      include_examples 'basic creation endpoint'

      it 'attaches the uploaded picture' do
        expect { req }.to change(ActiveStorage::Attachment, :count).by(2)
      end
    end

    context 'when ticket includes valid redeem discounts' do
      include_examples 'basic creation endpoint'

      it 'creates tickets discounts' do
        user_discounts
        expect { req }.to change(TicketDiscount, :count).by(1)
      end
    end

    context 'when ticket includes invalid redeem discounts' do
      include_examples 'basic creation endpoint'

      it 'does not create tickets discounts' do
        expect { req }.to change(TicketDiscount, :count).by(0)
      end
    end

    context 'when ticket creation fails' do
      let(:pictures) { nil }

      include_examples 'basic creation failure endpoint'
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end

    context 'when an unconfirmed user attempts to change discounts' do
      let(:user) { create(:user, :with_banking_info, confirmed_at: nil) }

      before do
        request.headers.merge! user.create_new_auth_token
        user_discounts
        req
      end

      it 'responds with forbidden status' do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #index' do
    subject(:req) { get :index }

    let(:user) { create(:user, :with_banking_info) }
    let(:current_user_tickets) { create_list(:ticket, 3, :with_pictures, user: user) }
    let(:other_users_tickets) { create_list(:ticket, 3, :with_pictures, :with_user) }

    context 'when gets list tickets' do
      before do
        request.headers.merge! user.create_new_auth_token
      end

      it 'responds with 200 status' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with tickets created by current_user' do
        current_user_tickets
        other_users_tickets
        req
        ticket_ids = JSON.parse(response.body)['data'].map { |ticket| ticket['id'].to_i }

        expect(user.reload.tickets.pluck(:id).sort).to eq(ticket_ids.sort)
      end
    end

    context 'when user is not logged in' do
      include_examples 'unauthorized when not logged in'
    end
  end
end
