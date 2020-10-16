class CreateUserDiscounts < ActiveRecord::Migration[5.1]
  def change
    create_table :user_discounts do |t|
      t.references :user, foreign_key: true
      t.references :discount, foreign_key: true

      t.timestamps
    end
  end
end
