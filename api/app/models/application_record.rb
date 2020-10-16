class ApplicationRecord < ActiveRecord::Base
  include Concerns::FastJsonSerializable
  include Concerns::TimeScopes

  acts_as_paranoid
  self.abstract_class = true

  def self.xls_columns
    column_names + [I18n.t('activerecord.general.attributes.deleted_status')]
  end

  def xls_attributes
    attributes.values + [deleted_status]
  end

  def deleted_status
    status = deleted_at.present? ? 'inactive' : 'active'
    I18n.t("activerecord.general.enums.deleted_status.#{status}")
  end
end
