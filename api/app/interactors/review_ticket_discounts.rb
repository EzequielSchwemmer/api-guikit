class ReviewTicketDiscounts
  include Interactor::Organizer

  organize SaveTicketDiscounts, NotifyTicketDiscounts
end
