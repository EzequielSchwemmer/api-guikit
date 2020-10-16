class ImageValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    return unless value.attached? && !image?(value)

    value.purge
    record.errors.add(:base, I18n.t(:wrong_format, scope: %i[pictures]))
  end

  private

  def image?(value)
    if value.class == ActiveStorage::Attached::Many
      value.all? { |picture| picture.blob.content_type.starts_with?('image/') }
    else
      value.content_type.starts_with?('image/')
    end
  end
end
