class ChangeDiscountFields < ActiveRecord::Migration[5.2]
  def change
    change_table :discounts do |t|
      t.string :discount_type, null: false, default: ''
      t.string :terms_and_conditions_url, null: false
      t.date :starts_at, null: false, default: 2.months.ago
      t.date :ends_at, null: false, default: 1.month.ago
      t.boolean :active, null: false, default: true
    end
  end
end
