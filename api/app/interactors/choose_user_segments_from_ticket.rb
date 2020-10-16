class ChooseUserSegmentsFromTicket
  include Interactor

  delegate :ticket, :params, :current_user, to: :context

  def call
    context.fail! if params.blank? || params[:segment_ids].nil?

    update_ticket
  end

  private

  def update_ticket
    Ticket.transaction do
      ticket.update!(ticket_params)
      ticket.user.update!(params)
    rescue StandardError
      context.fail!
    end
  end

  def ticket_params
    {
      segments_chooser: current_user,
      segments_chosen_at: Time.zone.now
    }
  end
end
