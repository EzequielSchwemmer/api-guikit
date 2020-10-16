class CreatePurchasedProductsByUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :purchased_products_by_users do |t|
      t.references :user, foreign_key: true, null: false
      t.references :product, foreign_key: true, null: false

      t.timestamps
    end
  end
end
