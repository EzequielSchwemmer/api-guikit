class TicketPolicy < AdminPolicy
  def create?
    return true if record.ticket_discounts.empty?

    user.is_a?(User) && user.confirmed?
  end

  def accept?
    user.allows?(:accept_ticket)
  end

  def reject?
    user.allows?(:reject_ticket)
  end

  def penalize?
    user.allows?(:penalize_ticket)
  end

  def digitalize?
    user.allows?(:digitalize_ticket)
  end

  def review?
    user.allows?(:review_ticket)
  end

  def assign_segments?
    user.allows?(:assign_segments_to_ticket)
  end

  def revert_review?
    user.allows?(:revert_review)
  end

  def index?
    user.allows?(:list_ticket_gallery)
  end

  def show?
    user.allows?(:show_ticket_gallery)
  end
end
