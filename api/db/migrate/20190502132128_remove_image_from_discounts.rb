class RemoveImageFromDiscounts < ActiveRecord::Migration[5.2]
  def change
    remove_column :discounts, :image, :string
  end
end
