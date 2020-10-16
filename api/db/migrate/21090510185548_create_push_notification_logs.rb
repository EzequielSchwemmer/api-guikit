class CreatePushNotificationLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :push_notification_logs do |t|
      t.string :title
      t.text :body
      t.string :type
      t.string :origin
      t.string :target_topic
      t.references :sender, references: :admin_user
      t.references :recipient, references: :user
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
