class CreateDiscountSteps < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_steps do |t|
      t.references :discount, foreign_key: true
      t.integer :position
      t.string :text

      t.timestamps
    end

    add_index :discount_steps, %i[discount_id position], unique: true
  end
end
