module FakeModels
  class SegmentPushNotification < Base
    class <<self
      def model_name
        @model_name ||= ActiveModel::Name.new(self, nil, 'SegmentPushNotification')
      end
    end

    attr_accessor :segment_ids, :title, :body

    validates :title, presence: true, length: { in: 1..50 }
    validates :body, presence: true, length: { in: 1..250 }
    validates :segment_ids, presence: true, length: { minimum: 2, body: :select_user }

    def segments
      Segment.where(id: segment_ids)
    end

    def receiver_ids
      segment_ids
    end
  end
end
