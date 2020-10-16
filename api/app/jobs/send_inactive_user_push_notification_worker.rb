require 'sidekiq-scheduler'

class SendInactiveUserPushNotificationWorker
  include Sidekiq::Worker

  def perform
    User.inactive.each do |user|
      body = body_for(user)
      type = SNS::NOTIFICATION_TYPE[:inactive_user]
      sns.publish(
        title, body, type, target_arn: user.device.endpoint_arn
      )
      log_notification(title, body, type, user)
    end
  rescue Aws::SNS::Errors::EndpointDisabled
    user.device.destroy
  end

  private

  def sns
    @sns ||= SNS.new
  end

  def title
    I18n.t('notifications.users.inactive.title')
  end

  def body_for(user)
    I18n.t('notifications.users.inactive.body', username: user.name)
  end

  def log_notification(title, body, type, recipient)
    PushNotificationLog.create!(
      title: title,
      body: body,
      notification_type: type,
      origin: :system,
      recipient: recipient
    )
  rescue StandardError => e
    Rails.logger.error(e)
  end
end
