class PermissionManager < ApplicationManager
  def permissions_for(role)
    FakeModels::RolePermissions.new(
      Permission.codes.keys.each_with_object({}) do |code, result|
        result[code] = role.allows?(code)
        result
      end
    )
  end

  def update_permissions!(role)
    role.permissions = select_permissions
    role.save!
  end

  private

  def select_permissions
    params.to_h.each_pair.with_object([]) do |pair, result|
      key, value = pair
      result << Permission.find_or_create_by!(code: key) if boolean_type.cast(value)
    end
  end

  def boolean_type
    @boolean_type ||= ActiveRecord::Type::Boolean.new
  end
end
