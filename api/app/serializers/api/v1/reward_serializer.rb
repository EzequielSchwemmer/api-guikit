module Api
  module V1
    class RewardSerializer < ApiSerializer
      attribute :points, :concept, :created_at
    end
  end
end
