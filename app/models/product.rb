class Product < ApplicationRecord
  belongs_to :category
  belongs_to :brand
  default_scope -> {order(created_at: :desc)}



end
