module Api
  module V1
    class CompleteUserInfoSerializer < UserSerializer
      has_one :banking_info, serializer: Api::V1::SimpleBankingInfoSerializer
    end
  end
end
