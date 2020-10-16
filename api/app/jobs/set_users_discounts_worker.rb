require 'sidekiq-scheduler'

class SetUsersDiscountsWorker
  include Sidekiq::Worker

  def perform
    User.includes(:device).find_each do |user|
      SetUserDiscounts.call(user: user)
    end
  end
end
