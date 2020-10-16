class Purchase < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  validates :ticket, :product, presence: true

  belongs_to :ticket
  belongs_to :product
end
