class AuditDashboard < ApplicationDashboard
  ATTRIBUTE_TYPES = {
    since: Field::Date,
    upto: Field::Date,
    limit: Field::Number,
    offset: Field::Number
  }.freeze

  FORM_ATTRIBUTES = %i[
    since upto limit offset
  ].freeze

  def resource_icon
    'download'
  end

  def display_resource(_resource)
    I18n.t('activerecord.models.audit.one')
  end
end
