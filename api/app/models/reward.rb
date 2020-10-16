class Reward < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable
  extend Concerns::CSVSerializable

  belongs_to :user
  belongs_to :ticket
  belongs_to :author, class_name: 'AdminUser'

  validates :points, numericality: {
    only_integer: true,
    less_than_or_equal_to: Rails.application.secrets.boost_points_limit
  }
end
