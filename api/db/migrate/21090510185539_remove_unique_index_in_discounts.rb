class RemoveUniqueIndexInDiscounts < ActiveRecord::Migration[5.2]
  def change
    remove_index(:discount_steps, column: %i[discount_id position])
  end
end
