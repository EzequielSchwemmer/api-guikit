class ChangeBirthdayToDateInUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :users, :birthday, :date, using: 'birthday::date'
    change_column :admin_users, :birthday, :date, using: 'birthday::date'
  end
end
