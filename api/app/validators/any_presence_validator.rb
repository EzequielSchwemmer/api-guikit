class AnyPresenceValidator < ActiveModel::Validator
  def validate(record)
    return if options[:fields].any? { |attr| record[attr].present? }

    record.errors.add(
      :base,
      I18n.t(:blank, scope: %i[any_presence]) + options[:fields].join(', ')
    )
  end
end
