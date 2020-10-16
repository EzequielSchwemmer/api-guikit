class AddReviewersToTickets < ActiveRecord::Migration[5.2]
  def change
    change_table(:tickets) do |t|
      t.references :quick_reviewer, index: true, references: :admin_users
      t.references :digitalizer, index: true, references: :admin_users
      t.references :reviewer, index: true, references: :admin_users
      t.references :exporter, index: true, references: :admin_users
    end
  end
end
