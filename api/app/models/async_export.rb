class AsyncExport < ApplicationRecord
  enum status: %i[pending working available removed canceled error]

  belongs_to :admin_user

  scope :in_process, -> { where(status: %i[pending working]) }

  def job
    return nil unless working?

    Sidekiq::ScheduledSet.new.find_job(job_id)
  end
end
