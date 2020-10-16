class UploadedTicketPolicy < TicketPolicy
  def index?
    user.allows_any?(:accept_ticket, :reject_ticket, :show_uploaded_ticket, :list_uploaded_tickets)
  end

  def show?
    user.allows_any?(:accept_ticket, :reject_ticket, :show_uploaded_ticket)
  end
end
