class UserDiscountDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    discount_id: Field::Number,
    discount_type: Field::VirtualString,
    title: Field::VirtualString
  }.freeze

  COLLECTION_ATTRIBUTES = %i[discount_id discount_type title].freeze
  SHOW_PAGE_ATTRIBUTES = %i[].freeze
  FORM_ATTRIBUTES = %i[].freeze
  EDIT_ATTRIBUTES = %i[].freeze
end
