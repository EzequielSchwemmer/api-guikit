class AddDeletedAtToModels < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :deleted_at, :datetime
    add_index :admin_users, :deleted_at

    add_column :banking_infos, :deleted_at, :datetime
    add_index :banking_infos, :deleted_at

    add_column :branches, :deleted_at, :datetime
    add_index :branches, :deleted_at

    add_column :daily_points, :deleted_at, :datetime
    add_index :daily_points, :deleted_at

    add_column :discount_segments, :deleted_at, :datetime
    add_index :discount_segments, :deleted_at

    add_column :discount_steps, :deleted_at, :datetime
    add_index :discount_steps, :deleted_at

    add_column :discounts, :deleted_at, :datetime
    add_index :discounts, :deleted_at

    add_column :permissions, :deleted_at, :datetime
    add_index :permissions, :deleted_at

    add_column :products, :deleted_at, :datetime
    add_index :products, :deleted_at

    add_column :purchases, :deleted_at, :datetime
    add_index :purchases, :deleted_at

    add_column :retailers, :deleted_at, :datetime
    add_index :retailers, :deleted_at

    add_column :rewards, :deleted_at, :datetime
    add_index :rewards, :deleted_at

    add_column :roles, :deleted_at, :datetime
    add_index :roles, :deleted_at

    add_column :segments, :deleted_at, :datetime
    add_index :segments, :deleted_at

    add_column :ticket_discounts, :deleted_at, :datetime
    add_index :ticket_discounts, :deleted_at

    add_column :ticket_lines, :deleted_at, :datetime
    add_index :ticket_lines, :deleted_at

    add_column :tickets, :deleted_at, :datetime
    add_index :tickets, :deleted_at

    add_column :user_discounts, :deleted_at, :datetime
    add_index :user_discounts, :deleted_at

    add_column :user_segments, :deleted_at, :datetime
    add_index :user_segments, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
