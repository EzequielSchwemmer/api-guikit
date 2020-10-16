class Role < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  validates :name, presence: true, uniqueness: true, length: { in: 1..40 }

  has_many :admin_users, dependent: :nullify

  has_and_belongs_to_many :permissions, join_table: 'role_permissions'

  def allows?(code)
    # Replaced for arrays to cache permissions instead of doing constant queries
    # Yes, not using SQL is actually a performance improvement in this case
    permissions.any? { |permission| permission.code&.to_sym == code.to_sym }
  end

  def allows_any?(*codes)
    permissions.any? { |permission| codes.include?(permission.code&.to_sym) }
  end

  def allows_all?(*codes)
    permission_codes = permissions.map(&:code).map(&:to_sym)
    codes.all? { |code| permission_codes.include?(code.to_sym) }
  end
end
