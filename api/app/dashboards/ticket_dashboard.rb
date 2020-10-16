require 'administrate/base_dashboard'

class TicketDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    user: Field::BelongsTo.with_options(searchable: true, searchable_field: 'name'),
    id: Field::Number.with_options(searchable: true, searchable_field: 'id'),
    created_at: Field::DateTime.with_options(searchable: false)
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    user
    created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    user
    id
    created_at
  ].freeze

  def resource_icon
    'photo'
  end

  def display_resource(ticket)
    display_name("Galería de ticket #{ticket.id}")
  end
end
