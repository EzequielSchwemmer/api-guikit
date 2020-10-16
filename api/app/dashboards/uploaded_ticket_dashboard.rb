class UploadedTicketDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    retailer: Field::BelongsTo,
    branch: Field::BelongsTo,
    user: Field::BelongsTo,
    reward: Field::HasOne,
    purchases: Field::HasMany,
    ticket_discounts: Field::HasMany,
    pictures_attachments: Field::HasMany.with_options(class_name: 'ActiveStorage::Attachment'),
    pictures_blobs: Field::HasMany.with_options(class_name: 'ActiveStorage::Blob'),
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    ticket_code: Field::String,
    total_cents: Field::Number,
    total_currency: Field::String,
    emitted_at: Field::DateTime,
    daily_counter: Field::Number,
    status: Field::String.with_options(searchable: false),
    total: Field::Money,
    retailer_name: Field::String,
    branch_name: Field::String
  }.freeze

  COLLECTION_ATTRIBUTES = %i[id created_at].freeze

  # This views are custom, so this values are not needed,
  # But they are still required by Administrate
  SHOW_PAGE_ATTRIBUTES = %i[].freeze
  FORM_ATTRIBUTES = %i[].freeze

  def display_resource(ticket)
    "Ticket ##{ticket.id}"
  end

  def resource_icon
    'paper-plane'
  end
end
