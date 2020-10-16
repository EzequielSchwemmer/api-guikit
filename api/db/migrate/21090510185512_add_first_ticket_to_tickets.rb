class AddFirstTicketToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :first_ticket, :boolean, null: false, default: false
  end
end
