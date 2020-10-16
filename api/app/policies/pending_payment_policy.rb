class PendingPaymentPolicy < AdminPolicy
  def index?
    user.allows?(:show_ticket_banking_info)
  end

  def export?
    index?
  end
end
