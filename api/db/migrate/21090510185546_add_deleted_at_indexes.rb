class AddDeletedAtIndexes < ActiveRecord::Migration[5.2]
  def change
    change_active_storage
    change_all_users
    change_banking_infos
    change_segments
    change_tickets
  end

  private

  def change_active_storage
    change_active_storage_attachments
    change_active_storage_blobs    
  end

  def change_all_users
    change_admin_users
    change_users
  end

  def change_banking_infos
    remove_index :banking_infos, name: :index_banking_infos_on_user_id
    add_index :banking_infos, %i[user_id deleted_at], unique: true
  end

  def change_segments
    remove_index :segments, name: :index_segments_on_name
    add_index :segments, %i[name deleted_at], unique: true
  end

  def change_tickets
    remove_index :tickets, name: :anti_fraud_ticket_protection
    add_index :tickets, %i[ticket_code emitted_at retailer_id branch_id deleted_at],
                        name: :anti_fraud_ticket_protection,
                        unique: true
  end

  def  change_active_storage_attachments
    add_column :active_storage_attachments, :deleted_at, :datetime
    remove_index :active_storage_attachments, name: :index_active_storage_attachments_uniqueness
    add_index :active_storage_attachments, %i[record_type record_id name blob_id deleted_at],
                                           unique: true,
                                           name: :index_active_storage_attachments_uniqueness
  end

  def change_active_storage_blobs
    add_column :active_storage_blobs, :deleted_at, :datetime
    remove_index :active_storage_blobs, name: :index_active_storage_blobs_on_key
    add_index :active_storage_blobs, %i[key deleted_at], unique: true
  end

  def change_admin_users
    remove_index :admin_users, name: :index_admin_users_on_email
    add_index :admin_users, %i[email deleted_at], unique: true

    remove_index :admin_users, name: :index_admin_users_on_reset_password_token
    add_index :admin_users, %i[reset_password_token deleted_at], unique: true
    
    remove_index :admin_users, name: :index_admin_users_on_unlock_token
    add_index :admin_users, %i[unlock_token deleted_at], unique: true  
  end

  def change_users
    remove_index :users, name: :index_users_on_confirmation_token
    add_index :users, %i[confirmation_token deleted_at], unique: true    

    remove_index :users, name: :index_users_on_email
    add_index :users, %i[email deleted_at], unique: true    

    remove_index :users, name: :index_users_on_reset_password_token
    add_index :users, %i[reset_password_token deleted_at], unique: true    

    remove_index :users, name: :index_users_on_uid_and_provider
    add_index :users, %i[uid provider deleted_at], unique: true
  end
end
