require 'aws-sdk-sns'

class SNS
  NOTIFICATION_TYPE = {
    specific_user: 'specific_user',
    inactive_user: 'inactive_user',
    points_update: 'points_update',
    discounts_update: 'discounts_update',
    segment: 'segment'
  }.freeze

  def create_topic(topic_name); end

  def destroy_topic(topic_name); end

  def create_endpoint(device); end

  def delete_endpoint(device); end

  def subscribe(device, topic); end

  def unsubscribe(device); end

  def publish(title, body, notification_type, **options); end

  def topic_arn(topic); end
end
