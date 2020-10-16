class CreateRefundXls
  include Interactor

  delegate :generator, :params, to: :context

  def call
    context.package = generator.export(exported_payments)
    context.payments = exported_payments
  rescue StandardError
    context.fail!
  end

  private

  def exported_payments
    @exported_payments ||= PendingPayment.where(user_id: selected_payments)
  end

  def selected_payments
    params[:payments]
      .values
      .filter(&method(:exported?))
      .map(&method(:map_selected_param))
  end

  def exported?(param)
    boolean_type.cast(param[:export])
  end

  def map_selected_param(param)
    param[:user_id]
  end

  def boolean_type
    @boolean_type ||= ActiveRecord::Type::Boolean.new
  end
end
