
class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.references :user, foreign_key: true, null: false
      t.string :token, null: false
      t.string :arn
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :devices, :deleted_at
  end
end
