class SetUserSnsTopics
  include Interactor

  delegate :user, :segments, to: :context

  def call
    segments.each do |segment|
      subscribe_to_topic(user, segment)
    end
  end

  private

  def subscribe_to_topic(user, segment)
    sns.subscribe(user.device, segment.topic_name)
    sns.unsubscribe(user.device)
  rescue Aws::SNS::Errors::NotFound => e
    Rails.logger.error(e)
  end

  def sns
    @sns ||= SNS.new
  end
end
