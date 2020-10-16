class CreateTicketLines < ActiveRecord::Migration[5.2]
  def change
    create_table :ticket_lines do |t|
      t.references :product, foreign_key: true, null: false
      t.references :ticket, foreign_key: true, null: false
      t.integer :amount
      t.monetize :price
      t.monetize :discount_price

      t.timestamps
    end
  end
end
