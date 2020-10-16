class AddProductDescriptionToDiscounts < ActiveRecord::Migration[5.2]
  def change
    add_column :discounts, :product_description, :string, null: false, default: 'Product Description'
  end
end
