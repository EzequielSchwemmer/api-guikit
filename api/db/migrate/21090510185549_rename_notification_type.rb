class RenameNotificationType < ActiveRecord::Migration[5.2]
  def change
    rename_column :push_notification_logs, :type, :notification_type
  end
end
