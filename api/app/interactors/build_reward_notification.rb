class BuildRewardNotification
  include Interactor

  delegate :params, :reward, to: :context
  delegate :concept, :points, :user_ids, to: :reward

  def call
    context.notification = FakeModels::PushNotification.new(
      title: I18n.t('reward.notifications.custom.title'),
      body: I18n.t('reward.notifications.custom.body', concept: concept, points: points),
      user_ids: user_ids
    )
    context.notification_type = SNS::NOTIFICATION_TYPE[:points_update]
  end
end
