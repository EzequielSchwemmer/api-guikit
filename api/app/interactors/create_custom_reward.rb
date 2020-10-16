class CreateCustomReward
  include Interactor::Organizer

  organize StoreReward, BuildRewardNotification, SendCustomPushNotification
end
