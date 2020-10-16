class AddExtraFieldsToTickets < ActiveRecord::Migration[5.1]
  def change
    change_table(:tickets) do |t|
      t.references :retailer, null: true, default: nil
      t.references :branch, null: true, default: nil
      t.string :ticket_code, null: true, default: nil
      t.monetize :total, null: true, default: nil
      t.datetime :emitted_at, null: true, default: nil
    end
  end
end
