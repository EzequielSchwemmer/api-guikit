class AddRejectReasonsToTicketDiscount < ActiveRecord::Migration[5.2]
  def change
    add_column :ticket_discounts, :reject_reason, :string
  end
end
