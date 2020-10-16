module Api
  module V1
    class TicketSerializer < ApiSerializer
      attribute :own_ticket
      attribute :pictures do |object|
        object.pictures.map do |picture|
          Rails.application.routes.url_helpers.rails_blob_url(picture)
        end
      end
      attribute :status, &:general_status
    end
  end
end
