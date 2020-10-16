module Admin
  class RewardsController < Admin::ApplicationController
    def new
      reward = FakeModels::Reward.new(notify: true)
      authorize reward
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, reward)
      }
    end

    def create
      reward = FakeModels::Reward.new(reward_attributes)
      authorize reward
      interactor = interactor_for(reward).call(
        reward: reward,
        current_user: current_admin_user
      )
      interactor.success? ? render_success : render_error(interactor.reward)
    end

    private

    def interactor_for(reward)
      reward.notify ? CreateCustomReward : StoreReward
    end

    def render_success
      flash[:notice] = I18n.t('admin.actions.rewards.success')
      redirect_to action: :new
    end

    def render_error(reward)
      flash[:error] = I18n.t('admin.actions.rewards.failure')
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, reward)
      }, status: :unprocessable_entity
    end

    def reward_attributes
      params.require(:reward).permit(:points, :concept, :notify, user_ids: [])
    end
  end
end
