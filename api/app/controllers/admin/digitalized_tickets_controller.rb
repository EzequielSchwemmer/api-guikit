module Admin
  class DigitalizedTicketsController < Admin::ApplicationController
    def review
      if valid_review?
        flash[:notice] = I18n.t('activerecord.messages.ticket.reviewed')
        redirect_to action: :index
      else
        render_error
      end
    end

    def show_search_bar?
      false
    end

    private

    def valid_review?
      TicketManager
        .new(current_admin_user, review_params)
        .validate_discounts(requested_resource)
        .success?
    end

    def review_params
      params
        .require(:digitalized_ticket)
        .permit(:refund, ticket_discounts_attributes: %i[id active reject_reason])
    end

    def render_error
      flash[:error] = I18n.t('activerecord.errors.models.ticket_discounts.invalid')
      redirect_back(fallback_location: admin_root_path)
    end
  end
end
