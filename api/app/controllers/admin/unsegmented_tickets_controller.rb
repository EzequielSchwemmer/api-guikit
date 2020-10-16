module Admin
  class UnsegmentedTicketsController < Admin::ApplicationController
    def assign_segments
      return render_errors unless segments_updated?

      flash[:notice] = I18n.t('activerecord.actions.ticket.assigned_segments')
      redirect_to action: :index
    end

    def show_search_bar?
      false
    end

    private

    def segments_updated?
      segments_assignment = manager.assign_segments(requested_resource)
      SetUserSnsTopics.call(
        user: user,
        segments: user.segments
      )
      SetUserDiscounts.call(user: user)
      segments_assignment.success?
    end

    def render_errors
      render :show, locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource)
      }, status: :unprocessable_entity
    end

    def assign_params
      params.require(:user).permit(segment_ids: [])
    end

    def manager
      @manager ||= TicketManager.new(current_admin_user, assign_params)
    end

    def user
      User.find(requested_resource.user_id)
    end
  end
end
