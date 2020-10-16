class AddAttributesToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :name, :string
    add_column :products, :category, :string
    add_column :products, :provider, :string
  end
end
