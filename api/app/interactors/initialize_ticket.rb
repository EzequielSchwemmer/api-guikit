class InitializeTicket
  include Interactor

  def call
    context.ticket = TicketManager.new(context.user, context.params).create!
  end
end
