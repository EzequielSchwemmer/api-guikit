class CreateRewards < ActiveRecord::Migration[5.1]
  def change
    create_table :rewards do |t|
      t.references :user, foreign_key: true
      t.references :ticket, foreign_key: true
      t.integer :points
      t.string :concept

      t.timestamps
    end
  end
end
