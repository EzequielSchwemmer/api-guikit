# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2109_05_10_185552) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id", "deleted_at"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "deleted_at"
    t.index ["key", "deleted_at"], name: "index_active_storage_blobs_on_key_and_deleted_at", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", null: false
    t.date "birthday", null: false
    t.bigint "role_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_admin_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_admin_users_on_email_and_deleted_at", unique: true
    t.index ["reset_password_token", "deleted_at"], name: "index_admin_users_on_reset_password_token_and_deleted_at", unique: true
    t.index ["role_id"], name: "index_admin_users_on_role_id"
    t.index ["unlock_token", "deleted_at"], name: "index_admin_users_on_unlock_token_and_deleted_at", unique: true
  end

  create_table "async_exports", force: :cascade do |t|
    t.bigint "admin_user_id", null: false
    t.integer "status", default: 0
    t.integer "job_id"
    t.string "filename"
    t.string "error"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_user_id"], name: "index_async_exports_on_admin_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "banking_infos", force: :cascade do |t|
    t.string "bank_name", null: false
    t.string "cbu"
    t.string "bank_alias"
    t.string "cuit", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "holder", default: true, null: false
    t.string "holder_name"
    t.index ["deleted_at"], name: "index_banking_infos_on_deleted_at"
    t.index ["user_id", "deleted_at"], name: "index_banking_infos_on_user_id_and_deleted_at", unique: true
  end

  create_table "branches", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "retailer_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_branches_on_deleted_at"
    t.index ["retailer_id"], name: "index_branches_on_retailer_id"
  end

  create_table "daily_points", force: :cascade do |t|
    t.integer "points"
    t.date "date"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_daily_points_on_deleted_at"
    t.index ["user_id"], name: "index_daily_points_on_user_id"
  end

  create_table "devices", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "token", null: false
    t.string "endpoint_arn"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscription_arn", default: [], array: true
    t.index ["deleted_at"], name: "index_devices_on_deleted_at"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "discount_segments", force: :cascade do |t|
    t.bigint "discount_id"
    t.bigint "segment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_discount_segments_on_deleted_at"
    t.index ["discount_id"], name: "index_discount_segments_on_discount_id"
    t.index ["segment_id"], name: "index_discount_segments_on_segment_id"
  end

  create_table "discount_steps", force: :cascade do |t|
    t.bigint "discount_id"
    t.integer "position"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_discount_steps_on_deleted_at"
    t.index ["discount_id"], name: "index_discount_steps_on_discount_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.bigint "cost"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "discount_type", default: "", null: false
    t.date "starts_at", default: "2020-08-14", null: false
    t.date "ends_at", default: "2020-09-14", null: false
    t.boolean "active", default: true, null: false
    t.boolean "featured", default: false, null: false
    t.text "terms_and_conditions", default: "", null: false
    t.datetime "deleted_at"
    t.string "product_description", default: "Product Description", null: false
    t.index ["deleted_at"], name: "index_discounts_on_deleted_at"
  end

  create_table "old_passwords", force: :cascade do |t|
    t.string "encrypted_password", null: false
    t.string "password_archivable_type", null: false
    t.integer "password_archivable_id", null: false
    t.string "password_salt"
    t.datetime "created_at"
    t.datetime "deleted_at"
    t.index ["password_archivable_type", "password_archivable_id"], name: "index_password_archivable"
  end

  create_table "permissions", force: :cascade do |t|
    t.integer "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_permissions_on_deleted_at"
  end

  create_table "product_discounts", force: :cascade do |t|
    t.bigint "product_id"
    t.bigint "discount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_product_discounts_on_discount_id"
    t.index ["product_id"], name: "index_product_discounts_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.string "name"
    t.string "category"
    t.string "provider"
    t.index ["deleted_at"], name: "index_products_on_deleted_at"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "product_id"
    t.integer "amount"
    t.bigint "total_retail_price"
    t.bigint "total_discount_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_purchases_on_deleted_at"
    t.index ["product_id"], name: "index_purchases_on_product_id"
    t.index ["ticket_id"], name: "index_purchases_on_ticket_id"
  end

  create_table "push_notification_logs", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.string "notification_type"
    t.string "origin"
    t.string "target_topic"
    t.bigint "sender_id"
    t.bigint "recipient_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id"], name: "index_push_notification_logs_on_recipient_id"
    t.index ["sender_id"], name: "index_push_notification_logs_on_sender_id"
  end

  create_table "retailers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_retailers_on_deleted_at"
  end

  create_table "rewards", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "ticket_id"
    t.integer "points"
    t.string "concept"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "author_id"
    t.index ["author_id"], name: "index_rewards_on_author_id"
    t.index ["deleted_at"], name: "index_rewards_on_deleted_at"
    t.index ["ticket_id"], name: "index_rewards_on_ticket_id"
    t.index ["user_id"], name: "index_rewards_on_user_id"
  end

  create_table "role_permissions", force: :cascade do |t|
    t.bigint "role_id"
    t.bigint "permission_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["permission_id"], name: "index_role_permissions_on_permission_id"
    t.index ["role_id"], name: "index_role_permissions_on_role_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_roles_on_deleted_at"
  end

  create_table "segments", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_segments_on_deleted_at"
    t.index ["name", "deleted_at"], name: "index_segments_on_name_and_deleted_at", unique: true
  end

  create_table "ticket_discounts", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "discount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true, null: false
    t.datetime "deleted_at"
    t.bigint "original_cost"
    t.string "reject_reason"
    t.index ["deleted_at"], name: "index_ticket_discounts_on_deleted_at"
    t.index ["discount_id"], name: "index_ticket_discounts_on_discount_id"
    t.index ["ticket_id"], name: "index_ticket_discounts_on_ticket_id"
  end

  create_table "ticket_lines", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "ticket_id", null: false
    t.integer "amount"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "ARS", null: false
    t.integer "discount_price_cents", default: 0, null: false
    t.string "discount_price_currency", default: "ARS", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_ticket_lines_on_deleted_at"
    t.index ["product_id"], name: "index_ticket_lines_on_product_id"
    t.index ["ticket_id"], name: "index_ticket_lines_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "retailer_id"
    t.bigint "branch_id"
    t.string "ticket_code"
    t.integer "total_cents", default: 0, null: false
    t.string "total_currency", default: "ARS", null: false
    t.datetime "emitted_at"
    t.bigint "user_id", null: false
    t.integer "daily_counter", default: 1, null: false
    t.integer "status", default: 0, null: false
    t.bigint "quick_reviewer_id"
    t.bigint "digitalizer_id"
    t.bigint "reviewer_id"
    t.bigint "exporter_id"
    t.datetime "quick_reviewed_at"
    t.datetime "digitalized_at"
    t.datetime "reviewed_at"
    t.datetime "exported_at"
    t.boolean "first_ticket", default: false, null: false
    t.integer "refund_cents", default: 0, null: false
    t.string "refund_currency", default: "ARS", null: false
    t.boolean "own_ticket", default: false
    t.datetime "deleted_at"
    t.bigint "segments_chooser_id"
    t.datetime "segments_chosen_at"
    t.string "reason_message"
    t.index ["branch_id"], name: "index_tickets_on_branch_id"
    t.index ["deleted_at"], name: "index_tickets_on_deleted_at"
    t.index ["digitalizer_id"], name: "index_tickets_on_digitalizer_id"
    t.index ["exporter_id"], name: "index_tickets_on_exporter_id"
    t.index ["quick_reviewer_id"], name: "index_tickets_on_quick_reviewer_id"
    t.index ["retailer_id"], name: "index_tickets_on_retailer_id"
    t.index ["reviewer_id"], name: "index_tickets_on_reviewer_id"
    t.index ["segments_chooser_id"], name: "index_tickets_on_segments_chooser_id"
    t.index ["ticket_code", "emitted_at", "retailer_id", "branch_id", "deleted_at"], name: "anti_fraud_ticket_protection", unique: true
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "user_discounts", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "discount_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_discounts_on_deleted_at"
    t.index ["discount_id"], name: "index_user_discounts_on_discount_id"
    t.index ["user_id"], name: "index_user_discounts_on_user_id"
  end

  create_table "user_segments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "segment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_user_segments_on_deleted_at"
    t.index ["segment_id"], name: "index_user_segments_on_segment_id"
    t.index ["user_id"], name: "index_user_segments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name", null: false
    t.string "email", null: false
    t.date "birthday", null: false
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "deleted_at"
    t.integer "gender", default: 0, null: false
    t.string "last_name"
    t.string "dni"
    t.index ["confirmation_token", "deleted_at"], name: "index_users_on_confirmation_token_and_deleted_at", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email", "deleted_at"], name: "index_users_on_email_and_deleted_at", unique: true
    t.index ["reset_password_token", "deleted_at"], name: "index_users_on_reset_password_token_and_deleted_at", unique: true
    t.index ["uid", "provider", "deleted_at"], name: "index_users_on_uid_and_provider_and_deleted_at", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admin_users", "roles"
  add_foreign_key "async_exports", "admin_users"
  add_foreign_key "banking_infos", "users"
  add_foreign_key "daily_points", "users"
  add_foreign_key "devices", "users"
  add_foreign_key "discount_segments", "discounts"
  add_foreign_key "discount_segments", "segments"
  add_foreign_key "discount_steps", "discounts"
  add_foreign_key "product_discounts", "discounts"
  add_foreign_key "product_discounts", "products"
  add_foreign_key "purchases", "products"
  add_foreign_key "purchases", "tickets"
  add_foreign_key "rewards", "tickets"
  add_foreign_key "rewards", "users"
  add_foreign_key "role_permissions", "permissions"
  add_foreign_key "role_permissions", "roles"
  add_foreign_key "ticket_discounts", "discounts"
  add_foreign_key "ticket_discounts", "tickets"
  add_foreign_key "ticket_lines", "products"
  add_foreign_key "ticket_lines", "tickets"
  add_foreign_key "tickets", "users"
  add_foreign_key "user_discounts", "discounts"
  add_foreign_key "user_discounts", "users"
  add_foreign_key "user_segments", "segments"
  add_foreign_key "user_segments", "users"

  create_view "pending_payments", sql_definition: <<-SQL
      SELECT max(tickets.id) AS id,
      tickets.user_id,
      users.deleted_at
     FROM (tickets
       JOIN users ON ((tickets.user_id = users.id)))
    WHERE ((tickets.status = 3) AND (users.deleted_at IS NULL))
    GROUP BY tickets.user_id, users.deleted_at;
  SQL
end
