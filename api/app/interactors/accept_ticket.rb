class AcceptTicket
  include Interactor::Organizer

  organize UpdateAcceptedTicket,
           SaveBoostRewardPoints,
           BuildPushNotification,
           SendCustomPushNotification,
           SaveReviewedTicket

  around do |interactor|
    Ticket.transaction do
      context.points = context.reward.presence
      interactor.call
    end
  end
end
