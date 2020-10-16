class UserDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    roles: Field::HasMany,
    segments: Field::HasMany,
    banking_info: Field::NiceHasOne,
    id: Field::Number,
    password: Field::Password,
    password_confirmation: Field::Password,
    sign_in_count: Field::Number,
    name: Field::String,
    email: Field::String,
    birthday: Field::Date,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    current_points: Field::Points,
    gender: Field::EnumSelect.with_options(model: User, enum: :genders),
    last_name: Field::String,
    dni: Field::String,
    discounts: Field::DiscountLink
  }.freeze

  COLLECTION_ATTRIBUTES = %I[id name email].freeze

  SHOW_PAGE_ATTRIBUTES = %I[
    name
    last_name
    dni
    email
    gender
    birthday
    sign_in_count
    banking_info
    current_points
    discounts
    segments
  ].freeze

  FORM_ATTRIBUTES = %I[
    name email last_name dni password password_confirmation gender birthday segments
  ].freeze

  EDIT_ATTRIBUTES = %I[
    name email last_name dni gender birthday segments
  ].freeze

  def resource_icon
    'users'
  end

  def display_resource(user)
    "#{user.name} #{user.last_name} - DNI #{user.dni}"
  end
end
