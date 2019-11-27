class Product < ApplicationRecord
  has_many :items, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :purchases, dependent: :destroy
  has_many :stocks, dependent: :destroy
  belongs_to :category
  belongs_to :brand
  default_scope -> {order(created_at: :desc)}

end
