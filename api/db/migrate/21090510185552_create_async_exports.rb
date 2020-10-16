class CreateAsyncExports < ActiveRecord::Migration[5.2]
  def change
    create_table :async_exports do |t|
      t.references :admin_user, foreign_key: true, null: false
      t.integer :status, default: 0 # pending
      t.integer :job_id
      t.string :filename
      t.string :error

      t.datetime :deleted_at
      t.timestamps
    end
  end
end
