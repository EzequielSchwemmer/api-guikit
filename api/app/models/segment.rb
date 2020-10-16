class Segment < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable

  after_create :set_sns_topic
  after_update :set_sns_topic
  after_destroy :destroy_sns_topic

  has_and_belongs_to_many :discounts, dependent: :destroy, join_table: 'discount_segments'
  has_many :users, through: :user_segments
  has_many :discount_segments, dependent: :destroy
  has_many :user_segments, dependent: :destroy

  validates :name, presence: true, length: { in: 1..80 }, uniqueness: true

  # Only way to set custom texts in administrate's collection selects
  def selection_format
    I18n.t('activerecord.formats.segment.selection', id: id, name: name)
  end

  def topic_name
    name.parameterize
  end

  private

  def set_sns_topic
    SNS.new.create_topic(topic_name)
  end

  def destroy_sns_topic
    SNS.new.destroy_topic(topic_name)
  end
end
