class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy

  VALID_STATUSES = %W[CART PENDING CHECKOUT PAYMENT COMPLETED CANCELLED]

  validates :status, inclusion: { in: VALID_STATUSES}
end
