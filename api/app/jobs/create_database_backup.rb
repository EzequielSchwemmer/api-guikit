class CreateDatabaseBackup
  include Sidekiq::Worker

  def perform(request_id)
    request = AsyncExport.find(request_id)
    return unless request.pending?

    request.update!(status: :working, job_id: jid)
    AsyncExport.transaction do
      perform_transaction(request)
    end
    BackupNotificationMailer.ready_email(request_id).deliver_now
  rescue StandardError => e
    request.update(status: :error, error: e.message)
    BackupNotificationMailer.failure_email(request_id).deliver_now
  end

  private

  def perform_transaction(request)
    generate_database_file
    request.update!(status: :available, filename: xls_filename)
  end

  def generate_database_file
    FileUtils.mkdir_p(tmp_folder)
    xls_generator.export(xls_generator.all_selected).serialize(xls_filename)
  end

  def xls_filename
    @xls_filename ||= File.join(tmp_folder, "database-#{DateTime.current.to_i}.xls")
  end

  def tmp_folder
    @tmp_folder ||= File.join(Dir.pwd, 'tmp', 'db', 'backups')
  end

  def xls_generator
    @xls_generator ||= Database::XlsGenerator.new
  end
end
