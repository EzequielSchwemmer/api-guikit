class User < ApplicationRecord
  devise :registerable,
         :lockable,
         :trackable,
         :database_authenticatable,
         :password_archivable,
         :secure_validatable,
         :recoverable,
         :timeoutable

  # BUG: should be included AFTER devise modules or it causes a bug in registrations
  include DeviseTokenAuth::Concerns::User
  # Added as a concern to share configurations.
  include Concerns::Auditable

  enum gender: { unknown: 0, male: 1, female: 2 }

  validates :name, :gender, presence: true, length: { in: 1..90 }
  validates :birthday, presence: true, age: true
  validates :email, uniqueness: { scope: :provider, case_sensitive: false }
  validates :avatar, body_size: true, image: true
  validates :dni, numericality: { only_integer: true }, allow_nil: true
  validates :dni, uniqueness: true

  has_one :banking_info, dependent: :destroy
  has_one :device, dependent: :destroy
  has_many :daily_points, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :tickets, dependent: :destroy
  has_many :user_discounts, -> { with_deleted }, inverse_of: :user
  has_many :ticket_discounts, through: :tickets
  has_many :discounts, through: :user_discounts
  has_many :user_segments, dependent: :destroy
  has_and_belongs_to_many :segments, dependent: :destroy, join_table: 'user_segments'
  has_many :received_notifications, class_name: 'PushNotificationLog',
                                    foreign_key: :recipient_id,
                                    inverse_of: :recipient,
                                    dependent: :nullify

  accepts_nested_attributes_for :banking_info
  accepts_nested_attributes_for :segments

  has_one_attached :avatar

  scope :for_point_calculation, -> { includes(:rewards, user_discounts: %i[discount]) }

  scope :inactive, lambda {
    includes(:device)
      .where("(SELECT max(value ->> 'expiry') FROM json_each(tokens)) < ?", 1.week.ago.to_i.to_s)
  }

  def self.xls_columns
    column_names + ['current_points', I18n.t('activerecord.general.attributes.deleted_status')]
  end

  # Added current_points as an attribute to be displayed in Administrate
  attribute(:current_points)
  def current_points
    Points::CurrentPointsCalculator.current_points(self)
  end

  # Overriding Devise method so it can be queued in Sidekiq
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # Only way to set custom texts in administrate's collection selects
  def selection_format
    I18n.t('activerecord.formats.user.selection', id: id, name: name, email: email)
  end

  def user_discounts_without_exchange
    user_discounts.where.not(discount_id: exchanged_discounts_ids)
  end

  protected

  # Users do not require confirmation, up to specific point
  def confirmation_required?
    false
  end

  private

  def exchanged_discounts_ids
    ticket_discounts.where(active: true).where.not(discount_id: nil).pluck(:discount_id)
  end
end
