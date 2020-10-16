class ChangeSubscriptionArnFromStringToArrayInDevices < ActiveRecord::Migration[5.2]
  def up
    change_column :devices, :subscription_arn, :string, array: true, default: [], using: "(string_to_array(subscription_arn, ','))"
  end

  def down
    change_column :devices, :subscription_arn, "varchar[]"
  end
end
