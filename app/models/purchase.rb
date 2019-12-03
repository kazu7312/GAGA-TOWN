class Purchase < ApplicationRecord
  belongs_to :user
  has_many :items
  has_many :products, through: :items
  belongs_to :product, optional: true
end
