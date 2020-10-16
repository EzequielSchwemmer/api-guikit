class SetInitialDiscounts
  include Interactor

  INITIAL_SEGMENT_NAME = Rails.application.secrets.initial_segment_name

  delegate :user, to: :context

  def call
    ApplicationRecord.transaction do
      initial_segment = Segment.find_or_create_by(name: INITIAL_SEGMENT_NAME)
      user.segments = [initial_segment]
      user.discounts = initial_segment.discounts
      sns.subscribe(user.device, initial_segment.topic_name)
      user.save!
    end
  end

  private

  def sns
    @sns ||= SNS.new
  end
end
