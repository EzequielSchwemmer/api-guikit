class UserDiscount < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  belongs_to :user
  belongs_to :discount, -> { with_deleted }, inverse_of: :user_discounts
  validates :user, :discount, presence: true

  delegate :discount_type, :title, to: :discount

  has_many :segments, through: :discount
  has_many :products, through: :discount
end
