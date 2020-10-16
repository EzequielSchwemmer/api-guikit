class DiscountSegment < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  belongs_to :discount
  belongs_to :segment
  validates :segment, :discount, presence: true
end
