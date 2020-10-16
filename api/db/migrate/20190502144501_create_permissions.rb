class CreatePermissions < ActiveRecord::Migration[5.1]
  def change
    create_table :permissions do |t|
      t.integer :code, unique: true

      t.timestamps
    end
  end
end
