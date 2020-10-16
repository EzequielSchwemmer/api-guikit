class Ticket < ApplicationRecord
  include Concerns::WithTicketStatus
  # Added as a concern to share configurations.
  include Concerns::Auditable

  # Refund is in ARS, but 100 cents = 1 ARS
  MAX_REFUND = Rails.application.secrets.max_ticket_refund * 100

  # 3 statuses to rull them all
  MAPPED_STATUSES =
    {}.with_indifferent_access.tap do |states|
      states.merge!(ACCEPTED_STATUSES.map { |state| [state, 'ACCEPTED'] }.to_h)
      states.merge!(REJECTED_STATUSES.map { |state| [state, 'REJECTED'] }.to_h)
      states.default = 'IN_PROCESS'
    end.freeze

  delegate :points, :points=, to: :reward
  delegate :present?, to: :segments_chooser, prefix: true
  delegate :present?, to: :segments_chosen_at, prefix: true

  monetize :total_cents
  monetize :refund_cents

  belongs_to :retailer, optional: true
  belongs_to :branch, optional: true
  belongs_to :user
  belongs_to :quick_reviewer, optional: true, class_name: 'AdminUser'
  belongs_to :digitalizer, optional: true, class_name: 'AdminUser'
  belongs_to :reviewer, optional: true, class_name: 'AdminUser'
  belongs_to :exporter, optional: true, class_name: 'AdminUser'
  belongs_to :segments_chooser, optional: true, class_name: 'AdminUser'
  has_many :ticket_discounts, -> { with_deleted }, inverse_of: :ticket, autosave: true
  has_many :discounts, through: :ticket_discounts
  has_one :reward, dependent: :nullify
  has_many :purchases, dependent: :destroy
  has_many :ticket_lines, dependent: :destroy, autosave: true
  has_many_attached :pictures

  accepts_nested_attributes_for :retailer
  accepts_nested_attributes_for :branch
  accepts_nested_attributes_for :ticket_lines
  accepts_nested_attributes_for :ticket_discounts

  enum status: %i[
    uploaded reviewed digitalized
    approved paid
    not_a_ticket blurred invalid_ticket too_old hit_limit penalized already_used
  ]

  validates :pictures, attached: true, body_size: true, image: true
  validates :user, presence: true

  validates :daily_counter, presence: true,
                            numericality: { only_integer: true, greater_than: 0 }

  validates :total_cents, :retailer, :branch, :quick_reviewer, :quick_reviewed_at,
            presence: true, if: :validate_digitalization?

  validates :ticket_code, :emitted_at, presence: true, if: :reviewed?

  validates :ticket_code, length: { in: 1...256 }, if: :reviewed?
  validates :total_cents, numericality: { only_integer: true, greater_than: 0 },
                          if: :validate_digitalization?

  validates :quick_reviewer, :quick_reviewed_at, presence: true, if: :quick_reviewed?
  validates :digitalizer, :digitalized_at, presence: true, if: :validate_digitalization?
  validates :reviewer, :reviewed_at, presence: true, if: :approved?
  validates :exporter, :exported_at, presence: true, if: :paid?

  validates :ticket_code,
            uniqueness: { scope: %i[emitted_at retailer_id branch_id] },
            if: :reviewed?

  validates :first_ticket, inclusion: { in: [true, false] }

  validates_associated :retailer, :branch, :ticket_lines, if: :validate_digitalization?

  validates :ticket_lines,
            length: {
              minimum: 1,
              too_short: I18n.t('activerecord.messages.ticket.ticket_lines_missing')
            },
            if: :validate_digitalization?

  validates :ticket_code,
            uniqueness: { scope: %i[retailer branch] },
            if: :reviewed?

  validates :refund_cents, :refund_currency, presence: true, if: :approved?
  validates :refund_cents,
            numericality: {
              only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: MAX_REFUND
            },
            if: :approved?
  validates :segments_chooser, presence: true, if: :segments_chosen_at_present?
  validates :segments_chosen_at, presence: true, if: :segments_chooser_present?

  # Note: The scopes were removed because rails 5 automatically creates
  #       an scope for each status, the only scopes are the ones than differ from
  #       the original status = 'status', and are status in [list]
  scope :approved, -> { where(status: %i[approved paid]) }
  scope :pending, -> { where(status: %i[uploaded reviewed digitalized]) }
  scope :rejected, -> { where(status: REJECTED_STATUSES) }
  scope :unsegmented, -> { digitalized.or(approved).where(segments_chosen_at: nil) }

  # This code is done this way to allow administrate to display this elements
  delegate :name, to: :retailer, prefix: true
  delegate :name, to: :branch, prefix: true

  def general_status
    MAPPED_STATUSES[status]
  end
end
