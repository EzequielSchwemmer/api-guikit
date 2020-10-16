class AddRefundToTickets < ActiveRecord::Migration[5.2]
  def change
    change_table(:tickets) do |t|
      t.monetize :refund
    end
  end
end
