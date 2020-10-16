class AddFeaturedToDiscounts < ActiveRecord::Migration[5.2]
  def change
    change_table :discounts do |t|
      t.boolean :featured, default: false, null: false
      t.text :terms_and_conditions, null: false, default: ''      
    end

    reversible do |dir|
      dir.up do
        remove_column :discounts, :terms_and_conditions_url
      end

      dir.down do
        t.string :terms_and_conditions_url, null: false, default: ''
      end
    end
  end
end
