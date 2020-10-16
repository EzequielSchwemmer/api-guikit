class ChangeTicketStatusToInteger < ActiveRecord::Migration[5.2]
  def up
    # It has to be done this way because it cannot cast string into integer
    # Not a problem since this was not on production, development or stage
    remove_column :tickets, :status
    add_column :tickets, :status, :integer, null: false, default: 0
  end

  def down
    remove_column :tickets, :status
    add_column :tickets, :status, :string
  end
end