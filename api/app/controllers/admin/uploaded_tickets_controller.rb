module Admin
  class UploadedTicketsController < Admin::ApplicationController
    def review
      if Ticket::REJECTED_STATUSES.include? params[:uploaded_ticket][:status]
        reject
      else
        accept
      end
    end

    def show_search_bar?
      false
    end

    private

    def reject
      authorize ticket, :reject?
      TicketManager.new(current_admin_user, reject_params).reject(ticket)
      return render_error unless ticket.valid?

      render_reject_success
    end

    def accept
      authorize ticket, :accept?
      TicketManager.new(current_admin_user, accept_params).accept(ticket)
      return render_error unless ticket.valid?

      render_accept_success
    end

    def ticket
      @ticket ||= UploadedTicket.find(params.require(:id))
    end

    def reject_params
      params
        .require(:uploaded_ticket)
        .permit(:ticket_code, :emitted_at, :status, :reason_message, reward: %i[points])
    end

    def accept_params
      params
        .require(:uploaded_ticket)
        .permit(:ticket_code, :emitted_at, :reason_message, reward: %i[points])
    end

    def render_error
      render locals: {
        page: Administrate::Page::Show.new(dashboard, ticket)
      }, action: :show, status: :unprocessable_entity
    end

    def render_reject_success
      flash[:notice] = I18n.t('activerecord.messages.ticket.rejected',
                              reason: I18n.t("activerecord.enums.ticket.status.#{ticket.status}"))
      redirect_to action: :index
    end

    def render_accept_success
      flash[:notice] = I18n.t('activerecord.messages.ticket.accepted')
      redirect_to action: :index
    end
  end
end
