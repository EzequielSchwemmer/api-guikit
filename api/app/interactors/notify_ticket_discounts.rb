class NotifyTicketDiscounts
  include Interactor

  delegate :ticket, :current_user, to: :context

  def call
    SendCustomPushNotificationWorker.perform_async(
      ticket.user.id,
      title_for(ticket),
      body_for(ticket),
      SNS::NOTIFICATION_TYPE[:points_update],
      current_user&.id
    )
  end

  private

  def title_for(ticket)
    I18n.t("notifications.users.tickets.discounts.#{ticket_state_for(ticket)}.title")
  end

  def body_for(ticket)
    I18n.t("notifications.users.tickets.discounts.#{ticket_state_for(ticket)}.body")
  end

  def ticket_state_for(ticket)
    return :positive if positive?(ticket.ticket_discounts)
    return :negative if negative?(ticket.ticket_discounts)

    :neutral
  end

  def positive?(discounts)
    discounts.all?(&:active)
  end

  def negative?(discounts)
    discounts.none?(&:active)
  end
end
