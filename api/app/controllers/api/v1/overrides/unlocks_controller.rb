module Api
  module V1
    module Overrides
      class UnlocksController < ::DeviseTokenAuth::UnlocksController
        def show
          if resource_class.unlock_access_by_token params[:unlock_token]
            redirect_to unlocked_path
          else
            redirect_to unlocked_failure_path
          end
        end

        def unlocked; end

        def unlocked_failure; end
      end
    end
  end
end
