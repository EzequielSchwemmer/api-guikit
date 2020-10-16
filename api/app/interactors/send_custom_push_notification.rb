class SendCustomPushNotification
  include Interactor

  delegate :notification, :current_user, :notification_type, to: :context

  def call
    context.fail! unless notification.valid?

    send_notifications(notification)
  rescue StandardError
    context.fail!
  end

  def send_notifications(notification)
    notification.receiver_ids.each do |id|
      next if id.blank?

      SendCustomPushNotificationWorker.perform_async(
        id,
        notification.title,
        notification.body,
        notification_type.nil? ? SNS::NOTIFICATION_TYPE[:points_update] : notification_type,
        current_user&.id
      )
    end
  end
end
