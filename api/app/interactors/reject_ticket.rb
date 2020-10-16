class RejectTicket
  include Interactor::Organizer

  organize UpdateRejectedTicket,
           SaveBoostRewardPoints,
           BuildPushNotification,
           SendCustomPushNotification

  around do |interactor|
    Ticket.transaction do
      context.points = context.penalty.presence
      interactor.call
    end
  end
end
