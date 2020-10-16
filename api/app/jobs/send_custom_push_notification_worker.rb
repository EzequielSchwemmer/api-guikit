class SendCustomPushNotificationWorker
  include Sidekiq::Worker

  def perform(resource_id, title, body, notification_type, sender_id = nil)
    sns.publish(
      title,
      body,
      notification_type,
      target(notification_type, resource_id)
    )
    log_notification(title, body, notification_type, sender_id, resource_id)
  rescue Aws::SNS::Errors::EndpointDisabled
    destroy_device(resource_id) if notification_type != SNS::NOTIFICATION_TYPE[:segment]
  end

  private

  def log_notification(title, body, type, sender_id, resource_id)
    for_segment = segment_notification?(type)
    PushNotificationLog.create!(
      title: title, body: body, notification_type: type, origin: :user,
      sender: sender_id.presence && User.find_by(id: sender_id),
      recipient: (!for_segment).presence && User.find(resource_id),
      target_topic: for_segment.presence && Segment.find(resource_id).topic_name
    )
  rescue StandardError => e
    Rails.logger.error(e)
  end

  def target(notification_type, resource_id)
    segment_notification?(notification_type) ? topic_arn(resource_id) : target_arn(resource_id)
  end

  def segment_notification?(notification_type)
    notification_type == SNS::NOTIFICATION_TYPE[:segment]
  end

  def topic_arn(resource_id)
    { topic_arn: sns.topic_arn(Segment.find(resource_id).topic_name) }
  end

  def target_arn(resource_id)
    { target_arn: User.find(resource_id).device&.endpoint_arn }
  end

  def destroy_device(resource_id)
    User.find(resource_id).device.destroy
  end

  def sns
    @sns ||= SNS.new
  end
end
