class RemoveRollifyRoles < ActiveRecord::Migration[5.1]
  def up
    drop_table(:users_roles)
    remove_column :roles, :resource_id
  end

  def down
    add_column :roles, :resource_id, :integer, polymorphic: true

    create_table(:users_roles, id: false) do |t|
      t.references :user
      t.references :role
    end

    add_index(:users_roles, [ :user_id, :role_id ])
  end
end
