module Concerns
  module WithTicketStatus
    extend ActiveSupport::Concern

    DIGITALIZED_STATUSES = %w[digitalized approved paid].freeze
    REJECTED_STATUSES = %w[
      not_a_ticket
      blurred
      invalid_ticket
      too_old
      hit_limit
      penalized
      already_used
    ].freeze
    ACCEPTED_STATUSES = %w[approved paid].freeze

    def validate_digitalization?
      DIGITALIZED_STATUSES.include?(status)
    end

    def rejected?
      REJECTED_STATUSES.include?(status)
    end

    def quick_reviewed?
      reviewed? || rejected? || validate_digitalization?
    end

    def reviewed?
      status == :reviewed || rejected?
    end
  end
end
