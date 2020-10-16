class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :ticket, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :amount
      t.bigint :total_retail_price
      t.bigint :total_discount_price

      t.timestamps
    end
  end
end
