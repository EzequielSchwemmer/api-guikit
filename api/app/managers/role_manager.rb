class RoleManager < ApplicationManager
  def build
    Role.new(name: params[:name])
  end

  def save(role)
    success = false
    Role.transaction do
      role.assign_attributes(default_params)
      role.save!
      update_permissions!(role)
      success = true
    rescue StandardError
      raise ActiveRecord::Rollback
    end
    success
  end

  private

  delegate :update_permissions!, to: :permission_manager

  def default_params
    params.slice(:name)
  end

  def permission_manager
    @permission_manager ||= PermissionManager.new(params[:permissions] || {})
  end
end
