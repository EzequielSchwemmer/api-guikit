class RewardDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    users: Field::HasMany.with_options(class_name: 'User'),
    concept: Field::String,
    points: Field::Points,
    notify: Field::Boolean
  }.freeze

  FORM_ATTRIBUTES = %i[
    users
    concept
    points
    notify
  ].freeze

  def resource_icon
    'trophy'
  end

  def display_resource(_resource)
    I18n.t('activerecord.models.reward.one')
  end
end
