class AdminUserPolicy < AdminPolicy
  def index?
    user.allows? :list_admin_users
  end

  def show?
    user.allows? :show_admin_user
  end

  def create?
    user.allows? :create_admin_user
  end

  def update?
    user.allows? :update_admin_user
  end

  def destroy?
    user.allows? :destroy_admin_user
  end
end
