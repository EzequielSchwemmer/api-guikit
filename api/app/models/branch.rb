class Branch < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable
  belongs_to :retailer

  validates :name, :retailer, presence: true

  validates :name, length: { in: 1..128 }
end
