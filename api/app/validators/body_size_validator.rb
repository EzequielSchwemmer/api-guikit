class BodySizeValidator < ActiveModel::EachValidator
  def validate_each(record, _attribute, value)
    return unless
      value.attached? && body_size(value) > Rails.application.secrets.client_max_body_size

    value.purge
    record.errors.add(:base, I18n.t(:wrong_size, scope: %i[pictures]))
  end

  private

  def body_size(value)
    if value.class == ActiveStorage::Attached::Many
      (value.map { |picture| picture.blob.byte_size }).sum
    else
      value.blob.byte_size
    end
  end
end
