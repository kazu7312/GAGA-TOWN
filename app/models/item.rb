class Item < ApplicationRecord
  belongs_to :product
  belongs_to :size
  belongs_to :cart
  belongs_to :purchase, optional: true

  def total_price
    self.quantity * self.product.price
  end
end
