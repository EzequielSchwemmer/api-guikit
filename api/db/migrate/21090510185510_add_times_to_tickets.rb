class AddTimesToTickets < ActiveRecord::Migration[5.2]
  def change
    change_table(:tickets) do |t|
      t.datetime :quick_reviewed_at
      t.datetime :digitalized_at
      t.datetime :reviewed_at
      t.datetime :exported_at
    end
  end
end
