class BankingInfo < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable
  NULL_ATTRS = %w[cbu bank_alias].freeze

  belongs_to :user
  validates :bank_name, :cuit, :user, presence: true
  validates :holder, inclusion: { in: [true, false] }
  validates :holder_name, presence: true, unless: -> { holder }
  validates_with AnyPresenceValidator, fields: %w[cbu bank_alias]
  validates :cbu, length: { is: 22 }, numericality: { only_integer: true }, allow_nil: true
  validates :bank_alias, length: { within: 6..20 }, allow_nil: true, uniqueness: true
  validates :cuit, length: { is: 11 }, numericality: { only_integer: true }
  validates :user, uniqueness: true
  before_validation :nil_if_blank

  protected

  def nil_if_blank
    NULL_ATTRS.each { |attr| self[attr] = nil if self[attr].blank? }
  end
end
