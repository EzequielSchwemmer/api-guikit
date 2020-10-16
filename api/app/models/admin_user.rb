class AdminUser < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  delegate :allows?, :allows_any?, :allows_all?, to: :role

  devise :registerable,
         :lockable,
         :database_authenticatable,
         :password_archivable,
         :secure_validatable,
         :recoverable

  belongs_to :role

  has_many :sended_notifications, class_name: 'PushNotificationLog',
                                  foreign_key: :sender_id,
                                  inverse_of: :sender,
                                  dependent: :nullify
  has_many :custom_rewards, class_name: 'Reward',
                            foreign_key: :author_id,
                            inverse_of: :author,
                            dependent: :nullify

  has_many :async_exports, dependent: :destroy

  validates :name, presence: true, length: { in: 1..90 }
  validates :birthday, presence: true, age: true

  # Add role as default in the model, for a quick optimization in administrate
  def self.find_for_authentication(warden_conditions)
    includes(role: %i[permissions]).find_by(email: warden_conditions[:email])
  end
end
