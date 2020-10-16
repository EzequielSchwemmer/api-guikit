module Admin
  class RolesController < Admin::ApplicationController
    # Copied from administrate's source to add permission_set
    def new
      resource = resource_class.new
      authorize_resource(resource)
      render locals: {
        page: Administrate::Page::Form.new(dashboard, resource)
      }
    end

    def create
      # Edites from Administrate's default method using most of the original code
      resource = manager.build
      authorize_resource(resource)
      if manager.save(resource)
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource('create.success')
        )
      else
        render_errors(resource, :new)
      end
    end

    # Copied from administrate's source to add permission_set
    def show
      render locals: {
        page: Administrate::Page::Show.new(dashboard, requested_resource)
      }
    end

    # Copied from administrate's source to add permission_set
    def edit
      render locals: {
        page: Administrate::Page::Form.new(dashboard, requested_resource)
      }
    end

    def update
      # requested_resource is already authorized in Administrate,
      # so no need to manually call authorize.
      if manager.save(requested_resource)
        redirect_to(
          [namespace, requested_resource],
          notice: translate_with_resource('update.success')
        )
      else
        render_errors(requested_resource, :edit)
      end
    end

    delegate :permissions_for, to: :permission_manager

    helper_method(:permissions_for)

    private

    def render_errors(resource, action)
      render action, locals: {
        page: Administrate::Page::Form.new(dashboard, resource)
      }, status: :unprocessable_entity
    end

    def resource_params
      params.require(:role).permit(:name, permissions: Permission.codes.keys)
    end

    def manager
      @manager ||= RoleManager.new(resource_params)
    end

    def permission_manager
      @permission_manager ||= PermissionManager.new({})
    end
  end
end
