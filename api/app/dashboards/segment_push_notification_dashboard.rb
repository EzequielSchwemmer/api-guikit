class SegmentPushNotificationDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    segment_ids: Field::Multiselect.with_options(model_name: 'Segment', format: :selection_format),
    title: Field::String,
    body: Field::Text
  }.freeze

  FORM_ATTRIBUTES = %i[
    segment_ids
    title
    body
  ].freeze
end
