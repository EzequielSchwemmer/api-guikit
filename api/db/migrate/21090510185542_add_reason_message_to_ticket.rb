class AddReasonMessageToTicket < ActiveRecord::Migration[5.2]
  def change
    add_column :tickets, :reason_message, :string
  end
end
