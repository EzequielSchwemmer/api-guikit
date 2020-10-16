class UserSegment < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  belongs_to :user
  belongs_to :segment
  validates :segment, :user, presence: true
end
