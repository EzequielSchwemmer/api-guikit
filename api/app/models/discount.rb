class Discount < ApplicationRecord
  IMAGE_SIZES = {
    thumbnail: { resize: '120x90>', extent: '120x90', background: 'white', gravity: 'center' }
  }.freeze
  # Added as a concern to share configurations.
  include Concerns::Auditable

  has_many :ticket_discounts, -> { with_deleted }, inverse_of: :discount
  has_and_belongs_to_many :segments, -> { with_deleted }, join_table: 'discount_segments'
  has_and_belongs_to_many :products, -> { with_deleted }, join_table: 'product_discounts'
  has_many :user_discounts, -> { with_deleted }, inverse_of: :discount
  has_many :users, through: :user_discounts
  has_many :steps,
           -> { order(position: :asc) },
           class_name: 'DiscountStep',
           inverse_of: :discount,
           dependent: :destroy,
           autosave: true
  has_one_attached :picture
  has_many :discount_segments, -> { with_deleted }, inverse_of: :discount

  accepts_nested_attributes_for :segments
  accepts_nested_attributes_for :products
  accepts_nested_attributes_for :steps, allow_destroy: true

  validates :cost, :title, :discount_type, :description, :product_description,
            :terms_and_conditions, :starts_at, :ends_at, presence: true
  validates :starts_at, timeliness: { on_or_before: :ends_at, message: :before_end }
  validates :ends_at, timeliness: { on_or_after: :starts_at, message: :after_start }
  validates :picture, attached: true, body_size: true, image: true
  validates :active, :featured, inclusion: { in: [true, false] }
  validates :title, :discount_type, :description, length: { in: 1..80 }
  validates_associated :steps
  validates_associated :segments

  scope :featured, -> { where(featured: true) }
  scope :active, -> { where(active: true) }
  scope :active_at, ->(date) { active.where('? between starts_at and ends_at', date) }
  scope :running, -> { active_at(Date.current).where(deleted_at: nil) }

  def picture_variant(size)
    picture.variant(combine_options: IMAGE_SIZES[size]).processed
  end
end
