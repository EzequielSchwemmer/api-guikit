class CreateRetailers < ActiveRecord::Migration[5.1]
  def change
    create_table :retailers do |t|
      t.string :name

      t.timestamps
    end
  end
end
