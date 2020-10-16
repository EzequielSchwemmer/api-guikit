module Api
  module V1
    module Overrides
      class RegistrationsController < ::DeviseTokenAuth::RegistrationsController
        def create
          super
          return if @resource.blank? || !@resource.persisted?

          RegisterDevice.call user: @resource, token: params[:device_token]
          SetUserSnsTopics.call(
            user: @resource,
            segments: @resource.segments
          )
        end

        private

        def update_auth_header
          SaveRegistrationRewardPoints.call user: @resource
          super
        end

        def render_create_success
          # I chose to include this here since this method is only called when the user
          # has been succesfully created, please see the original code: http://tiny.cc/y5et8y
          SetInitialDiscounts.call user: @resource
          render json: @resource, serializer: Api::V1::RewardedUserSerializer
        end

        def render_create_error
          render json: { data: { type: 'registration',
                                 attributes: { email: @resource.email,
                                               birthday: @resource.birthday,
                                               name: @resource.name,
                                               gender: @resource.gender,
                                               last_name: @resource.last_name,
                                               dni: @resource.dni },
                                 errors: @resource.errors.full_messages } },
                 status: :unprocessable_entity
        end
      end
    end
  end
end
