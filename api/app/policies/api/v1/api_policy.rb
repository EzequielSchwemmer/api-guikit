module Api
  module V1
    class ApiPolicy < ApplicationPolicy
      def create?
        user.id == record.user_id
      end

      def new?
        create?
      end

      def update?
        create?
      end

      def edit?
        update?
      end

      class Scope < Scope
        attr_reader :user, :scope

        def initialize(user, scope)
          @user  = user
          @scope = scope
        end

        def resolve
          # Override this for each policy
        end
      end
    end
  end
end
