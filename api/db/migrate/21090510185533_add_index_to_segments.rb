class AddIndexToSegments < ActiveRecord::Migration[5.2]
  def change
    add_index :segments, :name, unique: true
  end
end
