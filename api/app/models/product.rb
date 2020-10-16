class Product < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  has_many :purchases, dependent: :destroy
  has_many :ticket_lines, dependent: :destroy
  has_and_belongs_to_many :discounts, dependent: :destroy, join_table: 'product_discounts'

  validates :code, presence: true,
                   uniqueness: { case_sensitive: false },
                   numericality: { only_integer: true }

  def self.search(term)
    where('code LIKE :term', term: "%#{term.downcase}%")
  end
end
