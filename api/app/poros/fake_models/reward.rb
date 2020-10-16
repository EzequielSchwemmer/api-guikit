module FakeModels
  class Reward < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'Reward')
      end
    end

    include ActiveModel::Attributes

    attribute :user_ids
    attribute :concept, :string
    attribute :points, :integer
    attribute :notify, :boolean
    attr_reader :author

    validates :concept, presence: true, length: { in: 10..80 }
    validates :users, presence: true
    validates :points, numericality: {
      greater_than: 0,
      only_integer: true,
      less_than_or_equal_to: Rails.application.secrets.boost_points_limit
    }

    def real_rewards
      @real_rewards ||= users.pluck(:id).map do |id|
        ::Reward.new(user_id: id, concept: concept, points: points)
      end
    end

    def real_user_ids
      user_ids.is_a?(Array) ? user_ids : user_ids.values
    end

    def save!
      validate!
      real_rewards.each(&:save!)
    end

    def author=(value)
      @auhtor = value
      real_rewards.each { |reward| reward.author = value }
    end

    def users
      User.where(id: user_ids)
    end
  end
end
