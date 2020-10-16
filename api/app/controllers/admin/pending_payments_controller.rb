module Admin
  class PendingPaymentsController < Admin::ApplicationController
    def export
      context = RefundTickets.call(
        generator: generator, current_user: current_admin_user, params: export_params
      )
      return render_error if context.failure?

      render xlsx: 'export', filename: 'payments', locals: {
        package: context.package
      }
    end

    def show_search_bar?
      false
    end

    private

    def render_error
      flash[:alert] = I18n.t('admin.errors.payment.invalid')
      redirect_to action: :index
    end

    def export_params
      params
        .require(:pending_payments)
        .permit(payments: %i[export user_id])
    end

    def generator
      @generator ||= Payments::XlsGenerator.new
    end
  end
end
