class BuildPushNotification
  include Interactor

  def call
    context.notification = create_notification
    context.fail! unless notification.valid?
  end

  private

  delegate :title, :body, :user_ids, :notification, to: :context

  def create_notification
    FakeModels::PushNotification.new(
      title: title,
      body: body,
      user_ids: user_ids
    )
  end
end
