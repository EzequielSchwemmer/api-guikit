class CreatePendingPayments < ActiveRecord::Migration[5.2]
  def change
    create_view :pending_payments
  end
end
