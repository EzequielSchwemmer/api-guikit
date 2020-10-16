class ReviewedTicketPolicy < TicketPolicy
  def index?
    user.allows_any?(
      :digitalize_ticket, :revert_review, :show_reviewed_ticket, :list_reviewed_tickets
    )
  end

  def show?
    user.allows_any?(:digitalize_ticket, :revert_review, :show_reviewed_ticket)
  end
end
