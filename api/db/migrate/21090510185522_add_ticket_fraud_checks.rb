class AddTicketFraudChecks < ActiveRecord::Migration[5.2]
  def change
    add_index :tickets,
              %i[ticket_code emitted_at retailer_id branch_id],
              unique: true,
              name: 'anti_fraud_ticket_protection'
  end
end
