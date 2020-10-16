class TicketLineManager < ApplicationManager
  attr_reader :ticket

  def initialize(ticket, params)
    super(params)
    @ticket = ticket
  end

  def create
    ticket.ticket_lines.create(ticket_line_params)
  end

  private

  def ticket_line_params
    params
      .slice(:amount)
      .merge(
        product: product,
        price: Money.from_amount(params[:price].to_f),
        discount_price: Money.from_amount(params[:discount_price].to_f)
      )
  end

  def product
    @product = Product.find_by(code: code) ||
               Product.create(
                 code: code,
                 name: params[:product_attributes][:name],
                 category: params[:product_attributes][:category],
                 provider: params[:product_attributes][:provider]
               )
  end

  def code
    params[:product_attributes][:code]
  end
end
