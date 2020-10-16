class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.integer :status
      t.string :image

      t.timestamps
    end
  end
end
