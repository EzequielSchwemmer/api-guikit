module Admin
  class DiscountsController < Admin::ApplicationController
    # Original create at:
    # https://github.com/thoughtbot/administrate/blob/master/app/controllers/administrate/application_controller.rb
    # Added some modifications to use the DiscountManager
    def create
      resource = DiscountManager.new(current_user, resource_params).create
      authorize_resource(resource)
      return render_success(resource, 'create.success') if resource.persisted?

      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, resource)
      }, status: :unprocessable_entity
    end

    # Original update at:
    # https://github.com/thoughtbot/administrate/blob/master/app/controllers/administrate/application_controller.rb
    # Added some modifications to use the DiscountManager
    def update
      # Note: requested_resource is already authorized by Administrate's logic
      updated = DiscountManager.new(current_user, resource_params).update(requested_resource)
      return render_success(requested_resource, 'update.success') if updated

      render :edit, locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource)
      }, status: :unprocessable_entity
    end

    # Kept as public, because it is public on it's parent controller
    def resource_params
      params
        .require(:discount)
        .permit(
          :discount_type, :title, :description, :cost, :product_description,
          :starts_at, :ends_at, :active, :featured,
          :terms_and_conditions, :picture,
          steps_attributes: %i[id position text _destroy],
          segment_ids: []
        )
    end

    private

    def render_success(resource, notice)
      redirect_to(
        [namespace, resource],
        notice: translate_with_resource(notice)
      )
    end
  end
end
