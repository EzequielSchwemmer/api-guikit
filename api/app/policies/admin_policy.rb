class AdminPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    index?
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    create?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end
end
