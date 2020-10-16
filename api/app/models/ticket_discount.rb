class TicketDiscount < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  belongs_to :ticket
  belongs_to :discount, -> { with_deleted }, inverse_of: :ticket_discounts

  validates :ticket, :discount, presence: true
  validates :active, inclusion: { in: [true, false] }
  validates_with WithoutBankingInfoValidator

  scope :active, -> { where(active: true) }

  def self.xls_columns
    ['user_id'] + super + ['status']
  end

  def xls_attributes
    [ticket&.user_id] +
      super +
      [I18n.t("activerecord.enums.ticket_discount.ticket_status.#{ticket_status}")]
  end

  def ticket_status
    return :deleted if ticket.blank?
    return :rejected unless active

    ticket.paid? || ticket.approved? ? :accepted : :pending
  end
end
