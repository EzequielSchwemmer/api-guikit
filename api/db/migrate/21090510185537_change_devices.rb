class ChangeDevices < ActiveRecord::Migration[5.2]
  def change
    rename_column :devices, :arn, :endpoint_arn
    add_column :devices, :subscription_arn, :string
  end
end
