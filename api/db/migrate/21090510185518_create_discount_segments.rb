class CreateDiscountSegments < ActiveRecord::Migration[5.2]
  def change
    create_table :discount_segments do |t|
      t.references :discount, foreign_key: true
      t.references :segment, foreign_key: true
    end
  end
end
