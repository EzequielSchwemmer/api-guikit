require 'sidekiq-scheduler'

class SendAllTopicsPushNotificationWorker
  include Sidekiq::Worker

  TOPICS = %w[discounts].freeze

  def perform
    TOPICS.each do |topic|
      SendTopicPushNotificationWorker.perform_async(topic)
    end
  end
end
