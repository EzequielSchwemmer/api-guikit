class RemoveOldDatabaseBackup
  include Sidekiq::Worker

  def perform
    old_reports.find_each(batch_size: 10, &method(:remove_export))
  end

  private

  def old_reports
    AsyncExport.available
  end

  def remove_export(export)
    AsyncExport.transaction do
      export.update(status: :removed) if should_remove?(export)
    end
  end

  def should_remove?(export)
    return true unless File.exist?(export.filename)

    export.created_at < Rails.application.secrets.database_backup_storage_time.days.ago
  end
end
