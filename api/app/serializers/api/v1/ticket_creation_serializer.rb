module Api
  module V1
    class TicketCreationSerializer < TicketSerializer
      attribute :gained_points do
        Rails.application.secrets.ticket_reward_points
      end
    end
  end
end
