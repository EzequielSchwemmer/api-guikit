class PendingPaymentDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    total_refund: Field::Money,
    user_name: Field::String,
    bank_name: Field::String,
    bank_alias: Field::String,
    cbu: Field::String,
    cuit: Field::String,
    tickets: Field::HasMany,
    ticket_count: Field::Number
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    user_name bank_name cbu bank_alias cuit ticket_count total_refund
  ].freeze
end
