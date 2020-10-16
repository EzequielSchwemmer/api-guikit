class Permission < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  enum code: {
    # Codes used for Admin Users (100-199)
    list_admin_users: 100,
    create_admin_user: 101,
    show_admin_user: 102,
    update_admin_user: 103,
    destroy_admin_user: 104,
    update_admin_user_role: 105,
    # Codes used for Consumers (Application Users) (200-299)
    list_users: 200,
    create_user: 201,
    show_user: 202,
    update_user: 203,
    destroy_user: 204,
    show_users_banking_info: 205,
    # Codes used for Tickets (300-399)
    list_uploaded_tickets: 300,
    list_reviewed_tickets: 312,
    list_digitalized_tickets: 301,
    list_approved_tickets: 302,
    show_uploaded_ticket: 303,
    show_reviewed_ticket: 313,
    show_digitalized_ticket: 304,
    show_approved_ticket: 305,
    update_uploaded_ticket: 306,
    update_digitalized_ticket: 307,
    update_approved_ticket: 308,
    show_ticket_banking_info: 309,
    reject_ticket: 310,
    accept_ticket: 311,
    penalize_ticket: 315,
    digitalize_ticket: 314,
    review_ticket: 316,
    list_unsegmented_tickets: 317,
    show_unsegmented_ticket: 318,
    assign_segments_to_ticket: 319,
    revert_review: 320,
    list_ticket_gallery: 321,
    show_ticket_gallery: 322,
    # Codes used for roles (400-499)
    list_roles: 400,
    show_role: 401,
    update_role: 402,
    destroy_role: 403,
    create_role: 404,
    # Codes used for discounts (500-599)
    list_discounts: 500,
    show_discount: 501,
    update_discount: 502,
    destroy_discount: 503,
    edit_discount: 504,
    create_discount: 505,
    # Database codes (600-699)
    export_database: 600,
    import_user_segments: 601,
    export_audits: 602,
    # Segment codes (700-799)
    list_segments: 700,
    show_segment: 701,
    create_segment: 702,
    update_segment: 703,
    destroy_segment: 704,
    # Push notification codes (800-899)
    send_push_notifications: 800,
    # Codes for products (900-999)
    list_products: 900,
    show_product: 901,
    update_product: 902,
    destroy_product: 903,
    edit_product: 904,
    create_product: 905,
    # Reward codes (1000-1100)
    send_custom_rewards: 1000
  }

  has_and_belongs_to_many :roles, join_table: 'role_permissions'

  validates :code, presence: true, uniqueness: true
end
