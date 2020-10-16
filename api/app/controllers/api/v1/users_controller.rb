module Api
  module V1
    class UsersController < ApiController
      include RenderNested

      def show
        render_with_relation current_user,
                             related_models: [:banking_info],
                             serializer: Api::V1::CompleteUserInfoSerializer
      end

      def update
        authorize user, policy_class: Api::V1::UserPolicy
        user.update!(user_params)
        render json: user, serializer: Api::V1::UserSerializer
      end

      private

      def user
        @user ||= User.find(user_id)
      end

      def user_id
        params.require(:id)
      end

      def user_params
        params.require(:user).permit(:name, :email, :birthday, :gender, :avatar, :last_name, :dni)
      end
    end
  end
end
