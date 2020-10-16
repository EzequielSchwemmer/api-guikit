class AddDeletedAtToOldPasswords < ActiveRecord::Migration[5.2]
  def change
    add_column :old_passwords, :deleted_at, :datetime
  end
end
