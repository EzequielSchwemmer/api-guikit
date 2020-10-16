require 'sidekiq-scheduler'

class SendTopicPushNotificationWorker
  include Sidekiq::Worker

  def perform(topic)
    title = title_for(topic)
    body = body_for(topic)
    type = SNS::NOTIFICATION_TYPE[:discounts_update]
    sns.publish(
      title,
      body,
      type,
      topic_arn: sns.topic_arn(topic)
    )
    log_notification(title, body, type, sns.topic_arn(topic))
  end

  private

  def log_notification(title, body, type, target_topic)
    PushNotificationLog.create!(
      title: title,
      body: body,
      notification_type: type,
      origin: :system,
      target_topic: target_topic
    )
  rescue StandardError => e
    Rails.logger.error(e)
  end

  def sns
    @sns ||= SNS.new
  end

  def title_for(type)
    I18n.t("notifications.topics.#{type}.title")
  end

  def body_for(type)
    I18n.t("notifications.topics.#{type}.body")
  end
end
