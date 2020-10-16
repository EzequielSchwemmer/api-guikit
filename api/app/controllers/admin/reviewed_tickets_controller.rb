module Admin
  class ReviewedTicketsController < Admin::ApplicationController
    def recreate
      return revert if params[:revert].present?

      digitalize
    end

    def show_search_bar?
      false
    end

    private

    def revert
      authorize ticket, :revert_review?
      return render_digitalize_error unless ticket.update(status: :uploaded)

      flash[:notice] = I18n.t('activerecord.messages.ticket.reverted')
      redirect_to action: :index
    end

    def digitalize
      authorize ticket, :digitalize?
      TicketManager.new(current_admin_user, ticket_params).digitalize(ticket)
      return render_digitalize_error unless ticket.valid?

      render_digitalize_success
    end

    def render_digitalize_success
      flash[:notice] = I18n.t('activerecord.messages.ticket.digitalized')
      redirect_to action: :index
    end

    def render_digitalize_error
      # This is how Administrate handles page renders
      render locals: {
        page: Administrate::Page::Show.new(dashboard, ticket)
      }, action: :show, status: :unprocessable_entity
    end

    def ticket
      @ticket ||= ReviewedTicket.find(params.require(:id))
    end

    def ticket_params
      params
        .require(:reviewed_ticket)
        .permit(
          :total,
          retailer_attributes: %i[name], branch_attributes: %i[name],
          ticket_lines_attributes: [
            :amount, :price, :price_currency, :discount_price, :discount_price_currency,
            product_attributes: %i[code name category provider]
          ]
        )
    end
  end
end
