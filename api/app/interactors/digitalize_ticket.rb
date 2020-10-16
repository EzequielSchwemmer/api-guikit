class DigitalizeTicket
  include Interactor

  delegate :ticket, :params, :current_user, to: :context

  def call
    Ticket.transaction do
      ticket.status = ticket_status(ticket)
      ticket.assign_attributes(digitalize_params)
      create_ticket_lines
      ticket.save!
    # Handle any error on the ticket
    rescue StandardError
      context.fail!
    end
  end

  private

  def ticket_status(ticket)
    ticket.discounts.empty? ? :paid : :digitalized
  end

  def digitalize_params
    if ticket.discounts.empty?
      digitalized_ticket_params.merge(find_associations).merge(paid_ticket_params)
    else
      digitalized_ticket_params.merge(find_associations)
    end
  end

  def paid_ticket_params
    {
      exporter: current_user,
      exported_at: DateTime.current
    }
  end

  def find_associations
    {
      retailer: retailer,
      branch: branch,
      digitalizer: current_user,
      digitalized_at: Time.zone.now
    }
  end

  def retailer
    @retailer ||= RetailerManager.new(params[:retailer_attributes]).create
  end

  def branch
    @branch ||= BranchManager.new(retailer, params[:branch_attributes]).create
  end

  def digitalized_ticket_params
    params
      .slice
      .merge(
        total: Money.from_amount(params[:total].to_f),
        quick_reviewer: current_user,
        quick_reviewed_at: Time.zone.now
      )
  end

  def create_ticket_lines
    # Note: Rails likes to transform into nil empty arrays
    return [] if ticket_line_params.blank?
    # Note: Rails also has the tendency to convert arrays to a single element in the request
    #       when only one element is send.
    return [create_line(ticket_line_params)] if ticket_line_params[:product_attributes].present?

    ticket_line_params.values.map(&method(:create_line))
  end

  def create_line(line_params)
    TicketLineManager.new(ticket, line_params).create
  end

  def ticket_line_params
    @ticket_line_params ||= params[:ticket_lines_attributes]
  end
end
