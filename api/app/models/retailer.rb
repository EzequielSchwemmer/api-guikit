class Retailer < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  has_many :branches, dependent: :destroy

  validates :name, presence: true, length: { in: 1..128 }
end
