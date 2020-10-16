class BackupNotificationMailer < ApplicationMailer
  def ready_email(id)
    resource = AsyncExport.find(id)
    subject = I18n.t('admin.messages.database.async.email.ready')
    mail(to: resource.admin_user.email, subject: subject)
  end

  def failure_email(id)
    resource = AsyncExport.find(id)
    subject = I18n.t('admin.messages.database.async.email.error')
    mail(to: resource.admin_user.email, subject: subject)
  end
end
