class DigitalizedTicketPolicy < TicketPolicy
  def index?
    user.allows_any?(:review_ticket, :show_digitalized_ticket, :list_digitalized_tickets)
  end

  def show?
    user.allows_any?(:review_ticket, :show_digitalized_ticket)
  end
end
