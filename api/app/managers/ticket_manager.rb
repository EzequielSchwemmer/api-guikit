class TicketManager < ApplicationManager
  attr_reader :current_user

  def initialize(current_user, params = nil)
    super(params || ActionController::Parameters.new.permit)
    @current_user = current_user
  end

  def build
    Ticket.new(build_params)
  end

  def create!
    ticket = Ticket.create!(build_params)
    create_ticket_discounts(ticket)
    ticket
  end

  def digitalize(ticket)
    DigitalizeTicket.call(
      params: params,
      current_user: current_user,
      ticket: ticket
    )
  end

  def reject(ticket)
    RejectTicket.call(
      reason: params[:status],
      current_user: current_user,
      penalty: -reward_points,
      ticket: ticket,
      reason_message: params[:reason_message]
    )
  end

  def accept(ticket)
    AcceptTicket.call(
      ticket: ticket,
      current_user: current_user,
      reward: reward_points,
      reason_message: params[:reason_message],
      emitted_at: params[:emitted_at],
      ticket_code: params[:ticket_code]
    )
  end

  def validate_discounts(ticket)
    ReviewTicketDiscounts.call(
      params: params,
      current_user: current_user,
      ticket: ticket
    )
  end

  def assign_segments(ticket)
    ChooseUserSegmentsFromTicket.call(
      params: params,
      current_user: current_user,
      ticket: ticket
    )
  end

  private

  def create_ticket_discounts(ticket)
    ticket.ticket_discounts.create!(created_discounts)
  end

  def created_discounts
    discounts_ids_array.map do |id|
      discount = Discount.find(id)
      { discount_id: id, original_cost: discount.cost }
    end
  end

  def discounts_ids_array
    if params[:discounts].present?
      params[:discounts][:ids].map(&:to_i) & discounts_without_exchange_ids
    else
      []
    end
  end

  def discounts_without_exchange_ids
    current_user.user_discounts_without_exchange.pluck(:discount_id)
  end

  def reward_points
    params[:reward][:points].to_i
  end

  def review(ticket, ticket_params, reward)
    ReviewTicket.call(
      ticket: ticket,
      current_user: current_user,
      params: ticket_params,
      reward: reward
    )
  end

  def build_params
    params.merge(user_params).except(:discounts)
  end

  def user_params
    {
      user: current_user,
      status: :uploaded,
      daily_counter: daily_counter,
      first_ticket: current_user.tickets.count.zero?
    }
  end

  def daily_counter
    current_user.tickets.of_today.count + 1
  end
end
