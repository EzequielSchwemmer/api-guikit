class AddCostToTicketDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_table :ticket_discounts do |t|
      t.bigint :original_cost
    end
  end
end
