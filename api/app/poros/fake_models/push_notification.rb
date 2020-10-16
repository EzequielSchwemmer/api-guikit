module FakeModels
  class PushNotification < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'PushNotification')
      end
    end

    attr_accessor :user_ids, :title, :body

    validates :title, presence: true, length: { in: 1..50 }
    validates :body, presence: true, length: { in: 1..250 }
    validates :user_ids, presence: true

    def users
      User.where(id: user_ids)
    end

    def receiver_ids
      user_ids
    end
  end
end
