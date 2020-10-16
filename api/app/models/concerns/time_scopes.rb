module Concerns
  module TimeScopes
    extend ActiveSupport::Concern

    included do
      scope :of_day, ->(date) { where(created_at: date.all_day) }
      scope :of_today, -> { of_day(Time.zone.today) }
      scope :since, ->(date) { where('created_at >= ?', date) }
      scope :upto, ->(date) { where('created_at <= ?', date.to_datetime.end_of_day) }
    end
  end
end
