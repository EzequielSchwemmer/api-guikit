class AddRetailerToProducts < ActiveRecord::Migration[5.1]
  def change
    add_reference :products, :retailer, foreign_key: true
  end
end
