class PushNotificationLog < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  enum origin: {
    system: 'system',
    user: 'user'
  }

  belongs_to :sender, class_name: 'AdminUser', optional: true
  belongs_to :recipient, class_name: 'User', optional: true
end
