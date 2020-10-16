class AddOwnTicketToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :own_ticket, :boolean, default: false
  end
end
