class DiscountStep < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  belongs_to :discount

  validates :position, presence: true,
                       uniqueness: { scope: %i[discount_id] },
                       numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  validates :text, presence: true, length: { in: 1..80 }
end
