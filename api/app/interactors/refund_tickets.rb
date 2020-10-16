class RefundTickets
  include Interactor::Organizer

  organize CreateRefundXls, UpdateRefundedTickets
end
