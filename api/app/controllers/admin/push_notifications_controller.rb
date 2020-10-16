module Admin
  class PushNotificationsController < Admin::ApplicationController
    def new
      resource = FakeModels::PushNotification.new
      authorize resource, policy_class: PushNotificationPolicy
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
        segment_notification_page: Administrate::Page::Form.new(
          SegmentPushNotificationDashboard.new,
          FakeModels::SegmentPushNotification.new
        )
      }
    end

    def create
      resource = FakeModels::PushNotification.new(push_notification_params)
      authorize resource, policy_class: PushNotificationPolicy
      context = SendCustomPushNotification.call(
        current_user: current_admin_user,
        notification: resource,
        notification_type: SNS::NOTIFICATION_TYPE[:specific_user]
      )
      return render_error(resource) unless context.success?

      flash[:notice] = I18n.t('admin.actions.push_notifications.sent')
      redirect_to action: :new
    end

    def create_segment_notification
      resource = FakeModels::SegmentPushNotification.new(segment_push_notification_params)
      authorize resource, policy_class: PushNotificationPolicy
      context = SendCustomPushNotification.call(
        current_user: current_admin_user,
        notification: resource,
        notification_type: SNS::NOTIFICATION_TYPE[:segment]
      )
      segment_notification_flash(context)
    end

    private

    def render_error(resource)
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, resource),
        segment_notification_page: Administrate::Page::Form.new(
          SegmentPushNotificationDashboard.new,
          FakeModels::SegmentPushNotification.new
        )
      }, status: :unprocessable_entity
    end

    def segment_notification_flash(context)
      if context.success?
        flash[:notice] = I18n.t('admin.actions.push_notifications.sent')
      else
        flash[:error] = I18n.t('admin.actions.push_notifications.failed')
      end
      redirect_to new_admin_push_notification_path
    end

    def segment_push_notification_params
      params
        .require(:segment_push_notification)
        .permit(:title, :body, segment_ids: [])
    end

    def push_notification_params
      params
        .require(:push_notification)
        .permit(:title, :body, user_ids: [])
    end
  end
end
