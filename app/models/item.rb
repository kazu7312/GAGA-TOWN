class Item < ApplicationRecord
  belongs_to :product
  belongs_to :size
  belongs_to :cart
  belongs_to :purchase, optional: true
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 100 }
  validates :size_id, presence: true

  def total_price
    self.quantity * self.product.price
  end
end
