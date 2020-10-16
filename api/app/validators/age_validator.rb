class AgeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid_age, options) if value.present? && value > 16.years.ago
  end
end
