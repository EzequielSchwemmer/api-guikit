class Device < ApplicationRecord
  # Added as a concern to share configurations.
  include Concerns::Auditable
  belongs_to :user

  validates :token, presence: true

  before_create :create_endpoint
  before_destroy :destroy_endpoint

  def create_endpoint
    res = SNS.new.create_endpoint(self) # TODO: use worker
    self.endpoint_arn = res.endpoint_arn
  end

  def destroy_endpoint
    SNS.new.delete_endpoint(self) if endpoint_arn.present? # TODO: use worker
  rescue StandardError
    true
  end
end
