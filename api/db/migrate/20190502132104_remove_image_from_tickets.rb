class RemoveImageFromTickets < ActiveRecord::Migration[5.2]
  def change
    remove_column :tickets, :image, :string
  end
end
