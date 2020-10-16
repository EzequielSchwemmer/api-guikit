class UpdateRejectedTicket
  include Interactor

  delegate :current_user, :penalty, :reason, :ticket, :reason_message, to: :context

  def call
    context.fail! unless rejected_ticket?

    ticket.update!(ticket_params)
    update_ticket_discounts
    update_notification_context
  rescue StandardError
    context.fail!
  end

  private

  def rejected_ticket?
    Ticket::REJECTED_STATUSES.include?(reason)
  end

  def update_ticket_discounts
    ticket.ticket_discounts.update(active: false)
  end

  def update_notification_context
    context.title = title
    context.body = body
    # Rails process user_ids with '' as a first empty argument
    context.user_ids = ['', ticket.user.id]
  end

  def title
    I18n.t('notifications.users.tickets.rejected.title')
  end

  def body
    I18n.t('notifications.users.tickets.rejected.body', reason: localized_reason)
  end

  def localized_reason
    I18n.t("activerecord.enums.ticket.status.#{reason}")
  end

  def ticket_params
    {
      status: reason,
      quick_reviewer: current_user,
      quick_reviewed_at: Time.zone.now,
      reason_message: reason_message
    }
  end
end
