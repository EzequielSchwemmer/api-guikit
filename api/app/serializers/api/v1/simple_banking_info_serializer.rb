module Api
  module V1
    class SimpleBankingInfoSerializer < ApiSerializer
      attributes :bank_name, :cbu, :bank_alias, :cuit, :holder, :holder_name
    end
  end
end
