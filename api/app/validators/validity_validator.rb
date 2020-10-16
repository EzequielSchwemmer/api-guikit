class ValidityValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless value.blank? || value.valid?
  end
end
