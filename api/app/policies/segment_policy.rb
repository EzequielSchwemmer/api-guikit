class SegmentPolicy < AdminPolicy
  def index?
    user.allows? :list_segments
  end

  def show?
    user.allows? :show_segment
  end

  def create?
    user.allows? :create_segment
  end

  def update?
    user.allows? :update_segment
  end

  def destroy?
    user.allows? :destroy_segment
  end
end
