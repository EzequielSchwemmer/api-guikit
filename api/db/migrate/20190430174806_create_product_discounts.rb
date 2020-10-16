class CreateProductDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :product_discounts do |t|
      t.references :product, foreign_key: true
      t.references :discount, foreign_key: true

      t.timestamps
    end
  end
end
