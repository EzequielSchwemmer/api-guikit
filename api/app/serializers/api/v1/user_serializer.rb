module Api
  module V1
    class UserSerializer < ApiSerializer
      attributes :email, :name, :last_name, :dni, :birthday, :gender, :confirmed

      attribute :avatar do |object|
        if object.avatar.attached?
          Rails.application.routes.url_helpers.rails_blob_url(object.avatar)
        end
      end

      attribute(:confirmed, &:confirmed?)
    end
  end
end
