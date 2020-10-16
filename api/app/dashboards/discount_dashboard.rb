class DiscountDashboard < ApplicationDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    ticket_discounts: Field::HasMany,
    segments: Field::HasMany,
    products: Field::HasMany,
    user_discounts: Field::HasMany,
    users: Field::HasMany,
    steps: Field::HasMany.with_options(class_name: 'DiscountStep'),
    picture_attachment: Field::HasOne,
    picture_blob: Field::HasOne,
    id: Field::Number,
    cost: Field::Number,
    title: Field::String,
    description: Field::String,
    product_description: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    discount_type: Field::String,
    terms_and_conditions: Field::Text,
    starts_at: Field::Date,
    ends_at: Field::Date,
    active: Field::ReadableBoolean,
    featured: Field::ReadableBoolean
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    discount_type
    title
    starts_at
    ends_at
    active
    featured
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    discount_type
    title
    description
    product_description
    cost
    active
    featured
    starts_at
    ends_at
    terms_and_conditions
  ].freeze

  FORM_ATTRIBUTES = %i[
    discount_type
    title
    description
    product_description
    cost
    active
    featured
    starts_at
    ends_at
    terms_and_conditions
  ].freeze

  def display_resource(discount)
    display_name("(#{discount.discount_type}) #{discount.title}")
  end

  def resource_icon
    'tags'
  end
end
