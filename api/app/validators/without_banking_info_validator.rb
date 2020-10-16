class WithoutBankingInfoValidator < ActiveModel::Validator
  def validate(record)
    return if record.ticket.user&.banking_info.present?

    record.errors.add(
      :base,
      I18n.t(:blank, scope: %i[without_banking_info])
    )
  end
end
