class UnsegmentedTicketPolicy < TicketPolicy
  def index?
    user.allows?(:list_unsegmented_tickets)
  end

  def show?
    user.allows?(:show_unsegmented_ticket)
  end
end
