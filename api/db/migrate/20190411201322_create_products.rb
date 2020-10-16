class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :code, null: false, unique: true
      
      t.timestamps
    end
  end
end
