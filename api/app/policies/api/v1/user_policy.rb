module Api
  module V1
    class UserPolicy < ApiPolicy
      def create?
        user.id == record.id
      end
    end
  end
end
