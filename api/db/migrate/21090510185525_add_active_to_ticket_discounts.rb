class AddActiveToTicketDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :ticket_discounts, :active, :boolean, null: false, default: true
  end
end
