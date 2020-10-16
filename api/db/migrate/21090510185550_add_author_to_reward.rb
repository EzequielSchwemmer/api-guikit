class AddAuthorToReward < ActiveRecord::Migration[5.2]
  def change
    add_reference :rewards, :author, references: :admin_user
  end
end
