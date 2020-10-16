class PushNotificationDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    user_ids: Field::Multiselect.with_options(model_name: 'User', format: :selection_format),
    title: Field::String,
    body: Field::Text
  }.freeze

  FORM_ATTRIBUTES = %i[
    user_ids
    title
    body
  ].freeze
end
