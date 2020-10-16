class AddMissingTimestamps < ActiveRecord::Migration[5.2]
  def change
    change_table(:branches, &method(:add_timestamps))
    change_table(:discount_segments, &method(:add_timestamps))
    change_table(:role_permissions, &method(:add_timestamps))
  end

  def add_timestamps(table)
    table.timestamps null: true
  end
end
