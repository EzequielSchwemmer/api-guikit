class TicketLine < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  monetize :price_cents
  monetize :discount_price_cents

  belongs_to :product, autosave: true
  belongs_to :ticket

  accepts_nested_attributes_for :product

  validates :product, :ticket, :amount, :price_cents, :discount_price_cents, presence: true

  validates :amount, :price_cents, :discount_price_cents,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  validates_associated :product
end
