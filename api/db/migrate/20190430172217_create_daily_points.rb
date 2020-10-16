class CreateDailyPoints < ActiveRecord::Migration[5.1]
  def change
    create_table :daily_points do |t|
      t.integer :points
      t.date :date
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
