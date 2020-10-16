class RoleDashboard < ApplicationDashboard
  CODE_VALUES = {
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
    list_digitalized_tickets: 301,
    list_approved_tickets: 302,
    show_uploaded_ticket: 303,
    show_digitalized_ticket: 304,
    show_approved_ticket: 305,
    update_uploaded_ticket: 306,
    update_digitalized_ticket: 307,
    update_approved_ticket: 308,
    show_ticket_banking_info: 309,
    reject_ticket: 310,
    accept_ticket: 311,
    penalize_ticket: 315,
    # Codes used for roles (400-499)
    list_roles: 400,
    show_role: 401,
    update_role: 402,
    destroy_role: 403,
    # Codes used for discounts (500-599)
    list_discounts: 500,
    show_discount: 501,
    update_discount: 502,
    destroy_discount: 503
  }.freeze

  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    admin_users: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    permissions: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[id name].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    name
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    name
  ].freeze

  def display_resource(role)
    display_name(role.name)
  end

  def resource_icon
    'th-list'
  end
end
