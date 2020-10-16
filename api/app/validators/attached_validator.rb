class AttachedValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    record.errors.add(:base, I18n.t(:attached, scope: %i[pictures])) unless value.attached?
  end
end
