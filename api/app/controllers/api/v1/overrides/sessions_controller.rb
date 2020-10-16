module Api
  module V1
    module Overrides
      class SessionsController < ::DeviseTokenAuth::SessionsController
        def render_create_success
          render json: @resource, serializer: Api::V1::UserSerializer
        end

        def render_create_error_bad_credentials
          render json: { data: { type: 'session',
                                 errors: [
                                   I18n.t(:bad_credentials, scope: %i[devise_token_auth sessions])
                                 ] } },
                 status: :unauthorized
        end

        def create
          super
          return if @resource.nil?

          RegisterDevice.call user: @resource, token: params[:device_token]
          SNS.new.unsubscribe(@resource.device)
          SetUserSnsTopics.call(
            user: @resource,
            segments: @resource.segments
          )
        end
      end
    end
  end
end
