class DatabasePolicy < AdminPolicy
  def show?
    user.allows? :export_database
  end

  def export?
    show?
  end

  def import_user_segments?
    user.allows? :import_user_segments
  end

  def show_import_user_segments?
    import_user_segments?
  end
end
