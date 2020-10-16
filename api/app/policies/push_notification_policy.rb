class PushNotificationPolicy < AdminPolicy
  def create?
    user.allows? :send_push_notifications
  end

  def create_segment_notification?
    create?
  end
end
