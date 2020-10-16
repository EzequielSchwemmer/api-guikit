class SaveTicketDiscounts
  include Interactor

  delegate :ticket, :params, :current_user, to: :context

  def call
    Ticket.transaction do
      update_discounts
    rescue StandardError
      context.fail!
    end
  end

  private

  def update_discounts
    ticket.refund = Money.from_amount(params[:refund].to_f)
    ticket.assign_attributes(review_attributes)
    ticket.save!
    SetUserDiscounts.call(user: ticket.user)
  end

  def review_attributes
    params
      .slice(:ticket_discounts_attributes)
      .merge(
        status: :approved,
        reviewer: current_user,
        reviewed_at: DateTime.current
      )
  end
end
