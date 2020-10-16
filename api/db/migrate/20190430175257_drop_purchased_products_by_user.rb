class DropPurchasedProductsByUser < ActiveRecord::Migration[5.1]
  def change
    drop_table :purchased_products_by_users
  end
end
