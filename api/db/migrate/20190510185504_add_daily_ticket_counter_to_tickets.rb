class AddDailyTicketCounterToTickets < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :daily_counter, :integer, null: false, default: 1
  end
end
