class UpdateRefundedTickets
  include Interactor

  delegate :payments, :current_user, to: :context

  def call
    Ticket.transaction do
      payments.each do |payment|
        payment.tickets.find_each(&method(:update_ticket))
      end
    rescue StandardError
      context.fail!
    end
  end

  private

  def update_ticket(ticket)
    ticket.update!(
      exporter: current_user,
      exported_at: Time.zone.now,
      status: :paid
    )
  end
end
