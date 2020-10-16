# This is done to allow administrate handle them properly
class PendingPayment < ApplicationView
  belongs_to :user
  has_one :banking_info, through: :user
  has_many :tickets,
           -> { where(status: :approved) },
           through: :user,
           inverse_of: :user

  delegate :name, :email, :last_name, to: :user, prefix: true
  delegate :count, to: :tickets, prefix: 'ticket'
  delegate :bank_name, :bank_alias, :cbu, :cuit, to: :banking_info, allow_nil: true

  def total_refund
    tickets.map(&:refund).reduce(:+)
  end
end
