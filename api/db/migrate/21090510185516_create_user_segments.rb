class CreateUserSegments < ActiveRecord::Migration[5.2]
  def change
    create_table :user_segments do |t|
      t.references :user, foreign_key: true, null: false
      t.references :segment, foreign_key: true, null: false

      t.timestamps
    end
  end
end
