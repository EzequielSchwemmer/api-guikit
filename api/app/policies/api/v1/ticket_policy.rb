module Api
  module V1
    class TicketPolicy < ApiPolicy
      class Scope < Scope
        def resolve
          scope.where(user: user)
        end
      end
    end
  end
end
