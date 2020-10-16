class RegisterDevice
  include Interactor

  def call
    return if context.token.blank?

    find_record
    return if @device.user == context.user

    destroy_previous_device
    @device.user = context.user
    @device.save!
  end

  private

  def destroy_previous_device
    context.user.device&.transaction do
      unsubscribe_from_all
      context.user.device&.destroy
    end
  end

  def find_record
    @device = Device.find_or_initialize_by(token: context.token)
  end

  def unsubscribe_from_all
    context.user.device&.subscription_arn&.each do |arn|
      Aws::SNS::Client.new.unsubscribe(subscription_arn: arn)
    end
  end
end
