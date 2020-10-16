class AddHolderFieldsToBankingInfos < ActiveRecord::Migration[5.2]
  def change
    add_column :banking_infos, :holder, :boolean, null: false, default: true
    add_column :banking_infos, :holder_name, :string 
  end
end
