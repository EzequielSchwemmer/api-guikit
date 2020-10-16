class UpdateAcceptedTicket
  include Interactor

  delegate :ticket, :current_user, :reason_message, :emitted_at, :ticket_code, to: :context

  def call
    ticket.assign_attributes(ticket_params)
    update_notification_context
  end

  private

  def update_notification_context
    context.title = title
    context.body = body
    # Rails process user_ids with '' as a first empty argument
    context.user_ids = ['', ticket.user.id]
  end

  def title
    I18n.t('notifications.users.tickets.reviewed.title')
  end

  def body
    I18n.t('notifications.users.tickets.reviewed.body')
  end

  def ticket_params
    {
      status: :reviewed,
      quick_reviewer: current_user,
      quick_reviewed_at: Time.zone.now,
      reason_message: reason_message,
      ticket_code: ticket_code,
      emitted_at: emitted_at
    }
  end
end
