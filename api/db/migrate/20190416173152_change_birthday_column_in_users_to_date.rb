class ChangeBirthdayColumnInUsersToDate < ActiveRecord::Migration[5.1]
  def self.up
    change_column :users, :birthday, 'date USING CAST(birthday AS date)'
  end
 
  def self.down
    change_column :users, :birthday, :string
  end
end
