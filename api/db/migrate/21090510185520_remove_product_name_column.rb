class RemoveProductNameColumn < ActiveRecord::Migration[5.2]
  def change
    remove_column :products, :name, :string
  end
end
