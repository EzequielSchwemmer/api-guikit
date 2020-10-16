class ProductPolicy < AdminPolicy
  def index?
    user.allows? :list_products
  end

  def show?
    user.allows? :show_product
  end

  def create?
    user.allows? :create_product
  end

  def edit?
    user.allows? :update_product
  end

  def destroy?
    user.allows? :destroy_product
  end
end
