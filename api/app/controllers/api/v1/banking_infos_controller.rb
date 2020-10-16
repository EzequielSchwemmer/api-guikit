module Api
  module V1
    class BankingInfosController < ApiController
      def create
        banking_info = BankingInfo.create!(banking_info_params)
        render json: banking_info,
               serializer: Api::V1::BankingInfoCreationSerializer,
               status: :created
      end

      def update
        banking_info.assign_attributes(banking_info_params)
        authorize banking_info, policy_class: Api::V1::BankingInfoPolicy
        banking_info.update!(banking_info_params)
        render json: banking_info, serializer: Api::V1::BankingInfoSerializer
      end

      private

      def banking_info
        @banking_info ||= BankingInfo.find_or_initialize_by(user_id: params.require(:id))
      end

      def banking_info_params
        params
          .require(:banking_info)
          .permit(:bank_name, :cuit, :cbu, :bank_alias, :holder, :holder_name)
          .merge(user_id: current_user.id)
      end
    end
  end
end
