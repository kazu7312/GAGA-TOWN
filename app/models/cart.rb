class Cart < ApplicationRecord
  belongs_to :user
  has_many :items, dependent: :destroy
  has_many :products, through: :items

  def sub_total
    sum = 0
    self.items.each do |item|
      sum += item.total_price
    end
    return sum
  end
end
