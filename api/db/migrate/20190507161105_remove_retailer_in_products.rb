class RemoveRetailerInProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :retailer_id, :integer, foreign_key: true
  end
end
