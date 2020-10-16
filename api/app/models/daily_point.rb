class DailyPoint < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable
  belongs_to :user
end
