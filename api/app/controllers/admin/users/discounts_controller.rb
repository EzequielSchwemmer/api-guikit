module Admin
  module Users
    class DiscountsController < Admin::ApplicationController
      def index
        authorize user, :show?
        @user = user
        super
      end

      def refresh
        authorize user, :show?
        action = SetUserDiscounts.call(user: user)
        if action.success?
          flash[:notice] = I18n.t('admin.actions.users.discounts.refresh.success')
        else
          flash[:error] = I18n.t('admin.actions.users.discounts.refresh.error')
        end
        redirect_to action: :index
      end

      private

      def user
        @user ||= User.find(params.require(:user_id))
      end

      def scoped_resource
        user.user_discounts.joins(:discount)
      end

      def dashboard_class
        UserDiscountDashboard
      end
    end
  end
end
