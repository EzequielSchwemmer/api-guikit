class AddSegmentsChangerToTickets < ActiveRecord::Migration[5.2]
  def change
    change_table(:tickets) do |t|
      t.references :segments_chooser, references: :admin_users
      t.datetime :segments_chosen_at
    end
  end
end
