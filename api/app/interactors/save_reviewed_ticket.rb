class SaveReviewedTicket
  include Interactor

  delegate :ticket, to: :context

  def call
    ticket.save!
  rescue StandardError
    context.fail!
  end
end
