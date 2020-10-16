require 'sidekiq-scheduler'

class CleanDatabaseWorker
  include Sidekiq::Worker

  def perform
    return unless Rails.application.secrets.database_cleaner_trigger

    delete_ticket_related_data
    delete_user_related_data
    delete_discount_related_data

    delete_records(Product)
    delete_records(PushNotificationLog)
  end

  private

  def delete_ticket_related_data
    Ticket.transaction do
      delete_records(TicketLine)
      delete_records(TicketDiscount)
      delete_records(Ticket)
    end
  end

  def delete_user_related_data
    User.transaction do
      delete_records(Reward)
      delete_records(UserSegment)
      delete_records(BankingInfo)
      delete_records(UserDiscount)
      delete_records(Device)
      delete_records(User)
    end
  end

  def delete_discount_related_data
    Discount.transaction do
      delete_records(DiscountSegment)
      delete_records(DiscountStep)
      delete_records(Discount)
    end
  end

  def delete_records(klass)
    klass.with_deleted.each(&:really_destroy!)
    klass.all.each(&:really_destroy!)
  end
end
