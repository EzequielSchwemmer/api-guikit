class RolePolicy < AdminPolicy
  def index?
    user.allows? :list_roles
  end

  def show?
    user.allows? :show_role
  end

  def create?
    user.allows? :create_role
  end

  def update?
    user.allows? :update_role
  end

  def destroy?
    user.allows? :destroy_role
  end
end
