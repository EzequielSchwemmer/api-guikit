module Api
  module V1
    module Overrides
      class ConfirmationsController < ::DeviseTokenAuth::ConfirmationsController
        def confirm
          render :confirmed
        end
      end
    end
  end
end
