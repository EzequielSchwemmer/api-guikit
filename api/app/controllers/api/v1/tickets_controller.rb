module Api
  module V1
    class TicketsController < ApiController
      include RenderPaginated

      def index
        tickets = TicketPolicy::Scope.new(current_user, Ticket).resolve
        render_paginated tickets.order(created_at: :desc),
                         serializer: Api::V1::TicketIndexSerializer,
                         per_page: 20
      end

      def create
        Ticket.transaction do
          ticket = InitializeTicket.call(user: current_user, params: ticket_params).ticket
          authorize ticket
          SaveTicketRewardPoints.call user: current_user, ticket: ticket
          render json: ticket, serializer: Api::V1::TicketCreationSerializer, status: :created
        end
      end

      private

      def ticket_params
        params.require(:ticket).permit(:own_ticket, pictures: [], discounts: [ids: []])
      end
    end
  end
end
