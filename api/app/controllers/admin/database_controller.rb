module Admin
  class DatabaseController < Admin::ApplicationController
    def show
      authorize nil, policy_class: DatabasePolicy
      resource = DatabaseManager.new(generator.all_selected).build
      render locals: {
        page: Administrate::Page::Show.new(nil, resource)
      }
    end

    def export
      authorize export_params, policy_class: DatabasePolicy
      resource = DatabaseManager.new(export_params, option_params).build

      return render_export_errors(resource) unless resource.valid?

      render xlsx: 'export', filename: 'database', locals: {
        selected: export_params,
        options: option_params,
        generator: generator
      }
    end

    def show_import_user_segments
      authorize nil, policy_class: DatabasePolicy
      render locals: {
        object: FakeModels::Importer.new
      }
    end

    def import_user_segments
      authorize nil, policy_class: DatabasePolicy
      result = ImportUsersInfo.call(file: file_param)
      result.success? ? render_success(result) : render_error
      redirect_to action: :show_import_user_segments
    end

    private

    def render_success(result)
      flash_import(:alert, :not_found_users, result.not_found_users)
      flash_import(:notice, :segments_imported, result.segments_imported)
      flash_import(:success, :user_segments_imported, [1])
    end

    def render_error
      flash[:error] = I18n.t('admin.errors.database.import.user_segments')
    end

    def flash_import(key, i18n, arr)
      flash[key] = I18n.t("admin.messages.database.#{i18n}", count: arr.size) unless arr.empty?
    end

    def render_export_errors(resource)
      render action: :show, locals: {
        page: Administrate::Page::Show.new(nil, resource)
      }, status: :unprocessable_entity
    end

    def export_params
      @export_params ||= params.require(:export).permit(*generator.model_keys)
    end

    def option_params
      @option_params ||= begin
        value = params[:options]
          &.permit(:since, :upto, :limit, :offset, :spacing_rows, :spacing_columns)
        value || {}
      end
    end

    def generator
      @generator ||= Database::XlsGenerator.new
    end

    def file_param
      params.require(:importer).require(:file)
    end
  end
end
