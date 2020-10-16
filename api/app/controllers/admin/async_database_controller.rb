module Admin
  class AsyncDatabaseController < Admin::ApplicationController
    def show
      resource = AsyncExport.new(admin_user: current_admin_user)
      authorize resource, :export?, policy_class: DatabasePolicy
      render action: :show, locals: render_locals_for(resource)
    end

    def export
      resource = AsyncExport.new(admin_user: current_admin_user)
      authorize resource, policy_class: DatabasePolicy
      return render_limit_error(resource) if export_limit_reached?
      return render_export_errors(resource) unless resource.save

      perform_export(resource)
    end

    def download
      authorize resource, :export?, policy_class: DatabasePolicy
      unless File.exist?(resource.filename)
        flash[:error] = I18n.t('admin.messages.database.async.download.error')
        resource&.destroy
        return redirect_to action: :show
      end
      send(:send_file, resource.filename)
    end

    def destroy
      authorize resource, :export?, policy_class: DatabasePolicy
      result = nil
      AsyncExport.transaction do
        result = resource&.destroy ? :notice : :error
        flash[result] = I18n.t("admin.messages.database.async.destroyed.#{result}")
      end
      redirect_to action: :show
    end

    private

    def resource
      @resource ||= AsyncExport.find_by(id: params.require(:request_id))
    end

    def render_limit_error(resource)
      flash[:error] = I18n.t(
        'admin.errors.database.export_async.limit_reached', limit: export_limit
      )
      render_export_errors(resource)
    end

    def render_export_errors(resource)
      render action: :show,
             locals: render_locals_for(resource),
             status: :unprocessable_entity
    end

    def perform_export(resource)
      CreateDatabaseBackup.perform_async(resource.id)
      flash[:notice] = I18n.t('admin.messages.database.export_async.success')
      redirect_to action: :show
    end

    def export_limit_reached?
      AsyncExport.in_process.count >= export_limit
    end

    def export_limit
      Rails.application.secrets.async_export_limit
    end

    def render_locals_for(resource)
      {
        page: Administrate::Page::Show.new(nil, resource),
        in_process: AsyncExport.in_process,
        available: AsyncExport.available,
        export_limit: export_limit,
        export_days: Rails.application.secrets.database_backup_storage_time
      }
    end
  end
end
