module Api
  module V1
    class SimpleTicketSerializer < ApiSerializer
      attribute :status, &:general_status
    end
  end
end
