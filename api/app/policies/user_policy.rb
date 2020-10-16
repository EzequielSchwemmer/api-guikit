class UserPolicy < AdminPolicy
  def index?
    user.allows? :list_users
  end

  def show?
    user.allows? :show_user
  end

  def create?
    user.allows? :create_user
  end

  def update?
    user.allows? :update_user
  end

  def destroy?
    user.allows? :destroy_user
  end
end
