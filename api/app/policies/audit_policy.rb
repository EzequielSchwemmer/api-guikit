class AuditPolicy < AdminPolicy
  def index?
    false
  end

  def new?
    create?
  end

  def create?
    user.allows? :export_audits
  end
end
