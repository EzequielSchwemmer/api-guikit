module Admin
  class AuditsController < Admin::ApplicationController
    def new
      audit = FakeModels::Audit.new
      authorize audit, policy_class: AuditPolicy
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, audit)
      }
    end

    def create
      audit = FakeModels::Audit.new(audit_params)
      send_data audit.to_csv, filename: "audits-#{Date.current}.csv"
    rescue StandardError => e
      Rails.logger.error(e)
      render_error(audit)
    end

    private

    def render_error(audit)
      render :new, locals: {
        page: Administrate::Page::Form.new(dashboard, audit)
      }, status: :unprocessable_entity
    end

    def audit_params
      params.require(:audit).permit(:since, :upto, :limit, :offset)
    end
  end
end
