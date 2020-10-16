module Api
  module V1
    module Overrides
      class PasswordsController < ::DeviseTokenAuth::PasswordsController
        def edit
          cookies[:user_id] = params[:user_id].presence || resource_class
                              .with_reset_password_token(
                                resource_params[:reset_password_token]
                              ).id
          @resource = User.find(cookies[:user_id])
          cookies.delete :user_id
        end

        def update
          set_variables
          if @user.update(password: @password, password_confirmation: @password_confirmation)
            flash[:success] = I18n
                              .t('administrate.controller.update.success', resource: @user.email)
          else
            flash[:error] = @user.errors.full_messages
          end
          redirect_to edit_user_password_path(user_id: @user.id)
        end

        private

        def set_variables
          @user = User.find params[:user_id]
          @password = params[:user][:password]
          @password_confirmation = params[:user][:password_confirmation]
          @reset_password_token = params[:user][:reset_password_token]
        end

        def send_instructions(resource, config)
          resource.send_reset_password_instructions(
            email: resource.email,
            provider: 'email',
            client_config: config
          )
        end
      end
    end
  end
end
