class CreateDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :discounts do |t|
      t.bigint :cost
      t.string :title
      t.string :description
      t.string :image

      t.timestamps
    end
  end
end
