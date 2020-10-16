class SetUserDiscounts
  include Interactor

  delegate :user, to: :context

  def call
    ApplicationRecord.transaction do
      subscriptions(user, new_discounts)

      user.user_discounts.destroy_all
      user.discounts = available_discounts
      user.save!
    end
  end

  private

  def available_discounts
    @available_discounts ||=
      user.segments.each_with_object(used_discounts) do |segment, discounts_array|
        discounts_array.push(*segment.discounts.running)
      end
  end

  def new_discounts
    @new_discounts ||= available_discounts - old_discounts
  end

  def old_discounts
    @old_discounts ||= user.discounts.to_a
  end

  def used_discounts
    Discount.where(id: active_discounts.pluck(:discount_id)).to_a
  end

  def subscriptions(user, new_discounts)
    new_discounts.empty? ? sns.unsubscribe(user.device) : sns.subscribe(user.device, 'discounts')
  end

  def active_discounts
    user.ticket_discounts.includes(:ticket).active.reject { |td| td.ticket.rejected? }
  end

  def sns
    @sns ||= SNS.new
  end
end
