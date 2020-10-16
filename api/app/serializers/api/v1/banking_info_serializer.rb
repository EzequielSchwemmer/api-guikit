module Api
  module V1
    class BankingInfoSerializer < ApiSerializer
      attributes :bank_name, :cbu, :bank_alias, :cuit, :holder, :holder_name
      belongs_to :user
    end
  end
end
