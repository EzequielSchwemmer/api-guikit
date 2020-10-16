class DiscountPolicy < AdminPolicy
  def index?
    user.allows? :list_discounts
  end

  def show?
    user.allows? :show_discount
  end

  def create?
    user.allows? :create_discount
  end

  def edit?
    user.allows? :update_discount
  end

  def destroy?
    user.allows? :destroy_discount
  end
end
